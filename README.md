# NEO PageFactory

*by Des McCarter*

## Introduction

> Note: If you are familiar with Page Object patterns then you can skip this introduction and jump to [Install and Run](#installandrun).
> Also, take a look at a list of **example [page object pattern classes](#examples) generated by NEO PageFactory**.

### What is NEO PageFactory?

#### Background: SeleniumQA PageFactory

**NEO PageFactory is an extension to the well known and used Selenium QA PageFactory**. SeleniumQA PageFactory is a web/mobile testing utility that enables developers and testers to implement web / mobile based tests based on a testing pattern named the [Page Object Pattern](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/). 
> **Click [here](http://toolsqa.com/selenium-cucumber-framework/page-object-design-pattern-with-selenium-pagefactory-in-cucumber/)** for a **detailed description of the Page Object Pattern**. 

##### Quick Introduction to the Page Object Pattern

**In a nutshell, the Page Object Pattern is a one to one mapping of HTML pages (under test) to individual test classes**. These classes are then typically used during a test to automatically interact with the page itself. Page interaction happens via the classes getter and setter methods. These methods prepresent actions on page elements, typically for reading or writing text/data to these elements. Methods also normally exist for trigering physical page events, such as *click*, *doubleClick* etc.

###### The Page Object

**Creating an instance of a page (*object pattern*) class forms the page object**: an object which can be used to interact with the page under test. These interactions may include (for example) automatically filling in a form or reading a form or checking for the existence of elements after a certain action/event has been occurred.

### Problems when using SeleniumQA PageFactory

If Selenium QA PageFactory is used out of the box then all page classes are created manually by the tester (or developer). This can often lead to complications:

#### 1. Problems with element rich pages

Problems often occur in cases where web pages (under test) are very rich with page elements (i.e. where the number of elements on pages is significantly large and changable). 

#### 2. Acceptance Test Execution False Negatives

Problems can also occur around the initial stage of development from a testers perspective, where element id's, names, xpath locations etc are frequently changed by developers (especially when these changes are not expected). Time (and hence money) is then spent in an attempt to resolving these issues only to conclude these dev changes. This results in a false negative: a failing test failing due to communication between the developer(s) and test(ers). Time and money is hence wasted a. on the actual test execution and b. on the investigation.

### Problems can be minimised using NEO PageFactory

***NEO PageFactory was developed to (at least) minimise these issues***. It does so by by going one step further to SeleniumHQ PageFactory by ***GENERATING* all page classes being used for all tests**. 

#### NEO PageFactory Saves time 

##### ... by generating page classes

**NEO PageFactory reduces time taken in creating page (*object pattern*) classes, as these classes can be used straight away within the test**. This becomes very significant for element rich HTML pages.

##### ... because it can be used as part of (acceptance test related) UNIT Tests

Page generation can also be used at the UNIT testing stage for every build as a diff between page class generations. The latter becomes very useful because it minimises (dev page modification) issues during the acceptance testing phase (which is normally the stage that page modification issues are generally discovered).

### How does NEO PageFactory work?

**It works by scanning all HTML documents (via HTTP or a local HTML text file) for standard (or tailored) elements such as, input, a, select etc and, based on elements discovered, generates page object pattern based class files containing getters and setters**. These getters/setters (and action methods, such as *click*, *doubleClick* etc) represent the elements discovered on that page. The naming convension of each method is determined either by their element id's, name's or text used to display the element.

### Usage

1. Clone and Install neopagefactory
(NOTE: This step need only be done once)

```bash
# Assuming your root workspace for all projects is ~/projects
cd ~/projects

# Clone NEO PageFactory ...
git clone https://github.com/desmccarter/neopagefactory

# Go into the newly created/cloned folder ...
cd neopagefactory

# Install ...
mvn clean install
```

2. Generate Your POP (Page Object Pattern) Classes

```bash
# Assuming your project workspace is ~/projects/myproject
# and that you are working in a BASH instance ...

# Go to YOUR test project folder
cd ~/project/myproject

# Generate Google.com (for example) Page Object Pattern classes
# for your project ...

~/project/nopagefactory/generateclasses -url https://www.google.com
```

#### Page class output

**Page classes are (by default for now) created in the current working directory under src/main/java/com/dmcc/sample/pages**. The naming convention is *NameOfPagePage*.java, where *NameOfPage* is formed from the URL name. For example, a page class generated from *www.google.com* would have the name *GooglePage.java*, living under *src/main/java/com/dmcc/sample/pages/google*.

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

##### 1. No need to manually code your page classes

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

##### 2. Low level webdriver (etc) initialisation implied (hidden)

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

Test steps are now a lot clearer as to their intentions:

```java
...
	// Fire up a google page and render the first search page found by
	// searching for text (BJSS Location) ...

	@Test
	public void test01ImFeelingLucky() throws PageException{
		GooglePage page = new GooglePage().navigate();
		
		page.setQ("BJSS Location");
		page.clickIMFeelingLucky();
	}
	
	// Fire up a google page and list all pages found by 
	// searching for text (BJSS Location) ...

	@Test
	public void test02Search() throws PageException{
		GooglePage page = new GooglePage().navigate();
		
		page.setQ("BJSS Location");
		page.clickGoogleSearch();
	}
```

## Requirements

### Software Requirements

|Requirement|Version|
|--|--|
|Java SDK|1.8.0_144|
|Maven|3.5.0+|
|Bash|ANY|

> NOTE: Remember also to set-up your JAVA_HOME and MAVEN_HOME environment variables, along with supplying their *bin* locations in the *PATH* environment variable.

## Install and Run NEO PageFactory

<p name="installandrun"></p>

### Install

1. Open a bash instance

2. Go to a folder where you wish to install this project (I am using ~/projects in this example)
```bash
cd ~/projects
```

3. Clone [this](https://github.com/desmccarter/neopagefactory) project in bash.
```bash
git clone https://github.com/desmccarter/neopagefactory
```

4. Build and install this project 
```bash
cd neopagefactory
mvn clean install
```

### Run

> NOTE: this exmaple uses https://www.google.com but you can generate page classes with *any* URL

1. Go to your workspace folder (I am using. *~/projects/myproject* as an example).
```bash
cd ~/projects/myproject
```

2. Generate your page classes
```bash
~/projects/neopagefactory/generatepages.sh -url https://www.google.com
```

3. Classes will be generated by default in *your current location*/src/test/java/com/dmcc/sample/pages/*google*
> NOTE: The folder name *google* is taken from your *-url* argument.

```bash
-rw-r--r-- 1 Des.McCarter 1049089 317 Aug 13 08:56 GoogleField.java
-rw-r--r-- 1 Des.McCarter 1049089 862 Aug 13 08:56 GooglePage.java
```
> NOTE: GooglePage.java represents your page class. GoogleField.java represents the fields (web elements) that have been discovered on https://www.google.com.

## Generated POP Class Examples

Here are a few examples of POP (*Page Object Pattern*) classes generated using this utility.

<p name="examples"></p>

### Google.com

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

### Expedia.co.uk

```java
package com.dmcc.sample.pages.expedia;

import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.sample.pages.expedia.ExpediaField;
import com.dmcc.pagegen.page.mccarterp.McCarterPage;

public class ExpediaPage extends McCarterPage{

private final String url="https://www.expedia.co.uk";
private final String rRoot="../pgenexamples/src/test/resources";

	public ExpediaPage navigate()throws PageException {
		this.setResourcesRoot(rRoot);
		this.navigate(url);
		return this;
	}

	public void setGssSignupPassword(final String value) throws PageException{
		this.setValue(ExpediaField.GssSignupPassword, value);
	}

	public void clickGssSignupPassword()throws PageException{
		this.click(ExpediaField.GssSignupPassword);
	}

	public void clickGssJoinProgramCheck()throws PageException{
		this.click(ExpediaField.GssJoinProgramCheck);
	}

	public void clickGssMarketingEmailOptInCheck()throws PageException{
		this.click(ExpediaField.GssMarketingEmailOptInCheck);
	}

	public void clickGssMarketingEmailOptDefaultValue()throws PageException{
		this.click(ExpediaField.GssMarketingEmailOptDefaultValue);
	}

	public void setGssSigninPassword(final String value) throws PageException{
		this.setValue(ExpediaField.GssSigninPassword, value);
	}

	public void clickGssSigninPassword()throws PageException{
		this.click(ExpediaField.GssSigninPassword);
	}

	public void setFlightOriginHpFlight(final String value) throws PageException{
		this.setValue(ExpediaField.FlightOriginHpFlight, value);
	}

	public void clickFlightOriginHpFlight()throws PageException{
		this.click(ExpediaField.FlightOriginHpFlight);
	}

	public void setFlightDestinationHpFlight(final String value) throws PageException{
		this.setValue(ExpediaField.FlightDestinationHpFlight, value);
	}

	public void clickFlightDestinationHpFlight()throws PageException{
		this.click(ExpediaField.FlightDestinationHpFlight);
	}

	public void setFlight2OriginHpFlight(final String value) throws PageException{
		this.setValue(ExpediaField.Flight2OriginHpFlight, value);
	}

	public void clickFlight2OriginHpFlight()throws PageException{
		this.click(ExpediaField.Flight2OriginHpFlight);
	}
...
```

### Facebook.com

```java
package com.dmcc.sample.pages.facebook;

import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.sample.pages.facebook.FacebookField;
import com.dmcc.pagegen.page.mccarterp.McCarterPage;

public class FacebookPage extends McCarterPage{

private final String url="https://www.facebook.com";
private final String rRoot="../pgenexamples/src/test/resources";

	public FacebookPage navigate()throws PageException {
		this.setResourcesRoot(rRoot);
		this.navigate(url);
		return this;
	}

	public void setEmail(final String value) throws PageException{
		this.setValue(FacebookField.Email, value);
	}

	public void clickEmail()throws PageException{
		this.click(FacebookField.Email);
	}

	public void setPass(final String value) throws PageException{
		this.setValue(FacebookField.Pass, value);
	}

	public void clickPass()throws PageException{
		this.click(FacebookField.Pass);
	}

	public void clickLogIn()throws PageException{
		this.click(FacebookField.LogIn);
	}

	public void setFirstname(final String value) throws PageException{
		this.setValue(FacebookField.Firstname, value);
	}

	public void clickFirstname()throws PageException{
		this.click(FacebookField.Firstname);
	}

	public void setLastname(final String value) throws PageException{
		this.setValue(FacebookField.Lastname, value);
	}

	public void clickLastname()throws PageException{
		this.click(FacebookField.Lastname);
	}

	public void setRegEmail(final String value) throws PageException{
		this.setValue(FacebookField.RegEmail, value);
	}

	public void clickRegEmail()throws PageException{
		this.click(FacebookField.RegEmail);
	}
...
```

### Ocado.com

```java
import com.dmcc.pagegen.exceptions.PageException;
import com.dmcc.sample.pages.ocado.OcadoField;
import com.dmcc.pagegen.page.mccarterp.McCarterPage;

public class OcadoPage extends McCarterPage{

private final String url="https://www.ocado.com/webshop/quickReg.do";
private final String rRoot="../pgenexamples/src/test/resources";

	public OcadoPage navigate()throws PageException {
		this.setResourcesRoot(rRoot);
		this.navigate(url);
		return this;
	}

	public void setEntry(final String value) throws PageException{
		this.setValue(OcadoField.Entry, value);
	}

	public void clickEntry()throws PageException{
		this.click(OcadoField.Entry);
	}

	public void clickCustomerRegistrationOffersFlag()throws PageException{
		this.click(OcadoField.CustomerRegistrationOffersFlag);
	}

	public void setCustomerFirstName(final String value) throws PageException{
		this.setValue(OcadoField.CustomerFirstName, value);
	}

	public void clickCustomerFirstName()throws PageException{
		this.click(OcadoField.CustomerFirstName);
	}

	public void setCustomerLastName(final String value) throws PageException{
		this.setValue(OcadoField.CustomerLastName, value);
	}

	public void clickCustomerLastName()throws PageException{
		this.click(OcadoField.CustomerLastName);
	}

	public void setCustomerLogin(final String value) throws PageException{
		this.setValue(OcadoField.CustomerLogin, value);
	}

	public void clickCustomerLogin()throws PageException{
		this.click(OcadoField.CustomerLogin);
	}

	public void setCustomerPassword(final String value) throws PageException{
		this.setValue(OcadoField.CustomerPassword, value);
	}

	public void clickCustomerPassword()throws PageException{
		this.click(OcadoField.CustomerPassword);
	}

	public void setPostcode(final String value) throws PageException{
		this.setValue(OcadoField.Postcode, value);
	}

	public void clickPostcode()throws PageException{
		this.click(OcadoField.Postcode);
	}

	public void clickSearch()throws PageException{
		this.click(OcadoField.Search);
	}

	public void clickRegisterUsingPayPal()throws PageException{
		this.click(OcadoField.RegisterUsingPayPal);
	}

	public void clickRegister()throws PageException{
		this.click(OcadoField.Register);
	}
...
```
