# NEO PageFactory

## Introduction

### The Page Object Pattern

The **Page Object Pattern** is a method of representing web pages (to be tested) as a collection of classes/objects individually. 

#### Page Object Pattern - PageFactory Example

This example shows how the [Google Search Page](https://wwww.google.com) can be represented using the Page Object Pattern using the [SeleniumHQ PageFactoy](https://github.com/SeleniumHQ/selenium/wiki/PageFactory) library.

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

#### Page Object Pattern - NEO PageFactory Example

As seen in the **previous example, page classes are *manually coded*** by the tester/developer testing the page. **NEO Page Factory** goes one step further by ***dynamically generating* all classes for pages under test**.

##### Dynamically generated page class

```java
package com.dmcc.sample.pages.google;

import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.sample.pages.google.GoogleField;
import com.dmcc.pagegen.page.mccarterp.McCarterPage;

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
