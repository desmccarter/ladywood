# NEO PageFactory

## Introduction

### The Page Object Pattern

The **Page Object Pattern** is a method of representing web pages (to be tested) as a collection of classes/objects individually. For example, the [Google Search](https://wwww.google.com) page can be represented by a physical class named *GoogleSearchPage.java* for example. This page would then contain getters and setters for setting and retriving web element data.

#### Page Object Pattern Example

This example attempts to show how the [Google Search Page](https://wwww.google.com) can be represented using the Page Object Pattern. 

```java
package org.openqa.selenium.example;

import org.openqa.selenium.WebElement;

public class GoogleSearchPage {
    // Here's the element
    private WebElement q;

    public void searchFor(String text) {
        // And here we use it. Note that it looks like we've
        // not properly instantiated it yet....
        q.sendKeys(text);
        q.submit();
    }
}
```

The above page class, GoogleSearchPage, can then be used in a test (for example by searching for the text *Cheese*):

```java
package org.openqa.selenium.example;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import org.openqa.selenium.support.PageFactory;

public class UsingGoogleSearchPage {
    public static void main(String[] args) {
        // Create a new instance of a driver
        WebDriver driver = new HtmlUnitDriver();

        // Navigate to the right place
        driver.get("http://www.google.com/");

        // Create a new instance of the search page class
        // and initialise any WebElement fields in it.
        GoogleSearchPage page = PageFactory.initElements(driver, GoogleSearchPage.class);

        // And now do the search.
        page.searchFor("Cheese");
    }
}
```


**NEO PageFactory is an extension of** [SeleniumHQ PageFactory](https://github.com/SeleniumHQ/selenium/wiki/PageFactory). 

**SeleniumHQ PageFactory** (*PageFactory* for short) supports the [Page Object Pattern](https://raw.githubusercontent.com/wiki/SeleniumHQ/selenium/PageObjects.md).
> ***Page Object Pattern***: a method of structurally representing web pages (under test) as individual objects (classes).

Using Page**NEO Page Factory** goes one step further by ***GENERATING*** page classes for you.


