# NEO PageFactory

|Last Edited by|Date|
|---|---|
|Des McCarter|05/09/2018|

## Introduction

**NEO PageFactory is an extension to the** [SeleniumHQ PageFactoy](https://github.com/SeleniumHQ/selenium/wiki/PageFactory) **library**. 

### What is SeleniumHQ PageFactory?

PageFactory enables testers to implement web / mobile based tests based on the [Page Object Pattern](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/). In short, each page under test is mapped to an object (java, C#, ... class) with getters and setters of that class representing the *setting* and *getting* (and *clicking* etc) of page elements. **NEO PageFactory** goes one step further and *implements* page classes for you. It scans HTML documents and, based on elements found on all pages, generates page class files containing getters and setters etc representing the elements found.

> The **Page Object Pattern** is a method of representing web pages being tested as a collection of classes/objects individually. Each class represents a page and all pages have getter / setter methods representing the elements of that page.  

> **To find out more about the Page Object Pattern click** [here](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/).

#### SeleniumHQ PageFactory Example

Below is an example using the Page Object Pattern. There is a class named *GoogleSearchPage*. This class represents the actual [Google Search Page](https://wwww.google.com) with a method named *searchFor* representing both the search box and *q* submit button of www.google.com. This class was *hand crafted*, meaning that it was (or would have been) implemented by hand.

##### Manually coded page class using standard SeleniumQA PageFactory

```java
package org.openqa.selenium.example;

import org.openqa.selenium.WebElement;

// A manually crasfted class representing
// the Google Search page ...

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

*GoogleSearchPage* is then used in a test below (example test: search for the text *BJSS Location*):


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

#### NEO PageFactory Example

As seen in the **previous example, page classes are *manually coded*** by the tester/developer testing the page. **NEO Page Factory** goes one step further by ***dynamically generating* all classes for pages under test**.

##### Dynamically generated page class using NEO PageFactory

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

We can then use this class (*GooglePage*) within a test case, as can be seen below:

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

#### Advantages os NEO PageFactory

Note the difference between the the standard PageFactory and NEO PageFactory test implementations:

##### 1. All Google Search page web elements have methods implemented for them

**All elements found on the Google Search page have methods generated** (*Q* represents the search *text box*, *ImFeelingLucky* represents the *I'm Feeling Lucky button* (which renders the first page found in its search) and *GoogleSearch* represents the *standard Google Search button*.

###### Generated methods

```java
// Methods generated for Google Search page
// web elements ...

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
```

This is a simple example but the efficiency is more predominant for pages *richer* in web elements.

##### 2. Webdriver initialisation/setup and page navigation is implied

Web Driver initialisation is handled *outside* the actual test case by **implementing the *TestAbstract* class and *calling init/deinit*** (before and after test execution repectively). The page is then navigated to by calling the page objects `navigate()` method:


```java
	@Before
	public void setup(){
		// *** set-up webdriver (etc) ...
		init();
	}
	
	@After
	public void teardown(){
		// *** de-init webdriver (etc) ...
		deinit();
	}

...
// and page navigation ...
// (a. Get an instance of GooglePage b. fire up *a* browser and navigate to it ...)
...

		GooglePage page = new GooglePage().navigate();
```

The type of webdriver is supplied as a maven argument on test execution.

##### 3. Test case is a lot clearer as to what it is doing


