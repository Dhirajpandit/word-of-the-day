package com.english.voc.wof;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.IOException;
import java.net.URL;


@SpringBootApplication
public class WordOfTheDayApplication {

    public static void main(String[] args) throws IOException {
        SpringApplication.run(WordOfTheDayApplication.class, args);

    }




}
