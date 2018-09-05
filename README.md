# NEO PageFactory

## Introduction

### The Page Object Pattern

The **Page Object Pattern** is a method of representing web pages (to be tested) as a collection of classes/objects individually. For example, the [Google Search](https://wwww.google.com) page can be represented by a physical class named *GooglePage.java* for example. This page would then contain getters and setters for setting and retriving web element data.

**NEO PageFactory is an extension of** [SeleniumHQ PageFactory](https://github.com/SeleniumHQ/selenium/wiki/PageFactory). 

**SeleniumHQ PageFactory** (*PageFactory* for short) supports the [Page Object Pattern](https://raw.githubusercontent.com/wiki/SeleniumHQ/selenium/PageObjects.md).
> ***Page Object Pattern***: a method of structurally representing web pages (under test) as individual objects (classes).

Using Page**NEO Page Factory** goes one step further by ***GENERATING*** page classes for you.


