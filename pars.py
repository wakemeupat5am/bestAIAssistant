import json
import os

import cloudscraper
from bs4 import BeautifulSoup as BS

from utils import make_dirs, preprocess_text


def parser(keyword: str = "minecraft"):
    """
    Подготовка парсера
    """
    scraper = cloudscraper.create_scraper()
    persist_directory = os.path.join(os.getenv("data_path"), "scrapy")
    make_dirs(persist_directory)
    save_filename = preprocess_text(keyword)
    result_filename = f"{persist_directory}/{save_filename}.json"

    page = scraper.get("https://www.researchgate.net/search/publication?q="+keyword)
    data = BS(page.content, "html.parser")

    # Создаем пустой двумерный список для хранения имен ссылок и самих ссылок
    links_data = []
    urls = []

    for el in data.select(".nova-legacy-o-stack"):
        # Ищем все ссылки внутри элемента с классом "nova-legacy-v-publication-item__title"
        links = el.select(".nova-legacy-v-publication-item__title > a")
        # Добавляем имена и ссылки в двумерный список
        for link in links:
            a_name = link.text.strip()                                       # Имя ссылки
            a_href = "https://www.researchgate.net/" + link.get('href') 
            urls.append(a_href)     # Ссылка
            links_data.append({"name": a_name, "url": a_href})

    if os.path.exists(result_filename):
        os.remove(result_filename)

    json_data = []

    for url in urls:
        response = scraper.get(url)
        single_page = response.text
        single = BS(single_page, 'html.parser')
        element = single.find(class_="pdf-html-reader")
        if element:
            result_text = element.get_text()
            # Удаляем все пустые строки и добавляем строки в список
            text_list = [line for line in result_text.split("\n") if line.strip()]
            text_list = "\n".join([line for line in result_text.split("\n") if line.strip()])
            # Добавляем данные в список json_data
            json_data.append({
                "name": links_data[urls.index(url)]["name"],
                "url": url,
                "text": text_list
            })
        else:
            pass

    # Записываем данные в JSON файл
    with open(result_filename, "w", encoding="utf-8") as json_file:
        json.dump(json_data, json_file, ensure_ascii=False, indent=4)

    return result_filename
