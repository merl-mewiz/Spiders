# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'active_support'
require 'active_support/core_ext'

# Класс для сбора страктуры каталога и товаров с сайта https://ural-toys.ru
class UralExchange
  include HTTParty

  def initialize
    @base_uri = 'https://ural-toys.ru'
    @categories_items = '.c-categories__items'
    @categories_item = '.c-categories__item'
  end

  # получить все дерево каталога
  def catalog_get_recursive(target = '/catalog/')
    sleep(rand(0.3...2.0))
    result = []
    doc = page_get_content(target)

    if doc&.at_css(@categories_items)
      doc.at_css(@categories_items).css(@categories_item).each do |catalog_one_item|
        one_item_items = catalog_get_recursive(catalog_one_item[:href])
        one_item_items = {} if one_item_items == false
        result.push({
                      id: catalog_one_item[:href].delete('catalog').delete('/').to_i,
                      caption: catalog_one_item.css('.c-categories__item-name').text.strip,
                      href: catalog_one_item[:href],
                      sections: one_item_items
                    })
      end

      return result
    end

    false
  end

  # получить список всех товаров
  def catalog_get_items_list(target = '/catalog/')
    page = 1
    last_page = 1
    items = []

    while page <= last_page
      sleep(rand(0.3...2.0))

      doc = page_get_content(target, page)
      last_page = catalog_get_last_page(doc) if page == 1
      items += catalog_get_page_items(doc)
      page += 1
    end

    items
  end

  # получить html со страницы
  def page_get_content(target, page = 1)
    result = false
    query = "#{@base_uri}#{target}"
    query += "?page=#{page}" if page > 1

    begin
      response = self.class.get(query, { headers: { 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:30.0) Gecko/20100101 Firefox/30.0' } })
      result = Nokogiri::HTML(response.body)
      put_log("Запросили страницу: #{query}")
    rescue => e
      # TODO: Обработка ошибок
      put_log(e)
    end

    result
  end

  # получить товары с одной страницы
  def catalog_get_page_items(html)
    result = []

    unless html.nil?
      items_list = html&.at_css('.c-list__list')

      items_list.css('.c-list__item').each do |item|
        result.push({
                      caption: item.at_css('.card__title').text.strip,
                      href: item.at_css('.card__link')[:href],
                      section: item.at_css('.card__country')[:href].delete('catalog').delete('/').to_i
                    })
      end
    end

    result
  end

  # получить номер последней страницы
  def catalog_get_last_page(html)
    put_log('Ищем последнюю страницу')

    if html&.at_css('.c-list__pagination')
      last_page = html.css('.c-list__pagination-item').last.text.strip.to_i
      return last_page
    end

    false
  end

  # записать данные в xml файл
  def write_xml_file(xml_file_name, xml_content)
    put_log("Пишем в файл #{xml_file_name}")

    current_path = File.dirname(__FILE__)
    file_name = "#{current_path}/#{xml_file_name}_#{DateTime.now.strftime('%d_%m_%Y')}.xml"
    file = File.new(file_name, 'w:UTF-8')
    file.print(xml_content)
    file.close
  end

  # записать в лог
  def put_log(text)
    puts text
  end
end

parser = UralExchange.new
catalog_sections = parser.catalog_get_recursive
catalog_sections_xml = catalog_sections.to_xml(root: 'catalog-sections',
                                               children: 'catalog-section',
                                               indent: 2,
                                               skip_types: true)
parser.write_xml_file('catalog', catalog_sections_xml)

catalog_items = parser.catalog_get_items_list
catalog_items_xml = catalog_items.to_xml(root: 'catalog-items',
                                         children: 'catalog-item',
                                         indent: 2,
                                         skip_types: true)
parser.write_xml_file('catalog_items', catalog_items_xml)
