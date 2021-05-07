const puppeteer = require("puppeteer");

// we're using async/await - so we need an async function, that we can run
const run = async () => {
  // open the browser and prepare a page
  const browser = await puppeteer.launch()
  const page = await browser.newPage()

  
  await page.setDefaultNavigationTimeout(0);

  // set the size of the viewport, so our screenshot will have the desired size
  await page.setViewport({
      width: 1280,
      height: 800
  })

  await page.goto('https://fivethirtyeight.com/features/lots-of-people-in-cities-still-cant-afford-broadband/')

  
  await page.screenshot({
      path: '538_puppet.png',
      fullPage: true,
      waitUntil: 'load'
  })

  // close the browser 
  await browser.close();
};

// run the async function
run();