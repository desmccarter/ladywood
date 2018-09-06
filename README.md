# NEO PageFactory

|Last Edited by|Date|
|---|---|
|Des McCarter|05/09/2018|

## Introduction

**NEO PageFactory is an extension to the** [SeleniumHQ PageFactoy](https://github.com/SeleniumHQ/selenium/wiki/PageFactory) **library**. 

### What is SeleniumHQ PageFactory?

PageFactory enables testers to implement web / mobile based tests based on the [Page Object Pattern](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/). In short, each page under test is mapped to an object (java, C#, ... class) with getters and setters of that class representing the *setting* and *getting* (and *clicking* etc) of page elements. **NEO PageFactory** goes one step further and *implements* page classes for you. It scans HTML documents and, based on elements found on all pages, generates page class files containing getters and setters etc representing the elements found.

> The **Page Object Pattern** is a method of representing web pages being tested as a collection of classes/objects individually. Each class represents a page and all pages have getter / setter methods representing the elements of that page.  

> To find out more about the Page Object Pattern click [here](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/).

#### SeleniumHQ PageFactory Example

This example shows the use of the Page Object Pattern. Below is a class named *GoogleSearchPage* which represents the [Google Search Page](https://wwww.google.com). This class has has a method named *searchFor* representing both the search box and *q* submit button of www.google.com.

##### Manually coded page class using standard SeleniumQA PageFactory

```java
package org.openqa.selenium.example;

import org.openqa.selenium.WebElement;

// A page class written to represent the
// Google Search page ...

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

The above page class, GoogleSearchPage, can then be used in a test (for example by searching for the text *BJSS Location*):


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
        page.searchFor("BJSS Location");
    }
}
```

#### Page Object Pattern - NEO PageFactory Example

As seen in the **previous example, page classes are *manually coded*** by the tester/developer testing the page. **NEO Page Factory** goes one step further by ***dynamically generating* all classes for pages under test**.

##### Dynamically generated page class

```java
package com.dmcc.sample.pages.google;

import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.sample.pages.google.GoogleField;
import com.dmcc.pagegen.page.mccarterp.McCarterPage;

// Dynamically generated page class: generated from https://www.google.com ...

public class GooglePage extends McCarterPage{

private final String url="https://www.google.com";
private final String rRoot="../pgenexamples/src/test/resources";

	public GooglePage navigate()throws PageException {
		this.setResourcesRoot(rRoot);
		this.navigate(url);
		return this;
	}

	public void setQ(final String value) throws PageException{
		this.setValue(GoogleField.Q, value);
	}

	public void clickQ()throws PageException{
		this.click(GoogleField.Q);
	}

	public void clickGoogleSearch()throws PageException{
		this.click(GoogleField.GoogleSearch);
	}

	public void clickIMFeelingLucky()throws PageException{
		this.click(GoogleField.IMFeelingLucky);
	}

}
```

This page class (*GooglePage*) can then be used within a test case:

```java
package com.dmcc.pgenexamples.google;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.pgenexamples.TestAbstract;
import com.dmcc.sample.pages.google.GooglePage;

public class GoogleTests extends TestAbstract {
	
	@Before
	public void setup(){
		init();
	}
	
	@After
	public void teardown(){
		deinit();
	}
	
	@Test
	public void test01ImFeelingLucky() throws PageException{
		GooglePage page = new GooglePage().navigate();
		
		page.setQ("BJSS Location");
		page.clickIMFeelingLucky();
	}
	
	@Test
	public void test02Search() throws PageException{
		GooglePage page = new GooglePage().navigate();
		
		page.setQ("BJSS Location");
		page.clickGoogleSearch();
	}
}
```
