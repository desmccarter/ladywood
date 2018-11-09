using OpenQA.Selenium;

namespace pagefactory.webdriverhandler
{
    public abstract class DriverWrapper
    {
        public IWebDriver CurrentDriver
        {
            get; set;
        }

        public DriverWrapper()
        {
            initialiseDriver();
        }

        protected abstract void initialiseDriver();
    }
}
