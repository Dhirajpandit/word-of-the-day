package com.english.voc.wof.controller;

import com.english.voc.wof.model.Word;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/wod")
public class VocubularyController {

    @GetMapping("/today")
    public Word wordOfTheDay() throws IOException {
        return readUrl();
    }

    public Word readUrl() throws IOException {
        Document document = Jsoup.connect("https://www.dictionary.com/e/word-of-the-day/").get();
        Elements elements = document.getElementsByClass("otd-item-headword__word");
        Elements desc = document.getElementsByClass("otd-item-headword__pos");
        Elements example = document.getElementsByClass("wotd-item-example__content");
        Word word = new Word();
        word.setWordOfDay(elements.get(0).text());
        word.setMeaning(desc.get(0).child(1).text());
        word.setExample(example.get(0).text());
        return word;
    }

}
