const puppeteer = require('puppeteer-extra');


(async () => {
    const StealthPlugin = require('puppeteer-extra-plugin-stealth')
    puppeteer.use(StealthPlugin())
    const browser = await puppeteer.launch({
        headless: false,
        executablePath: '/usr/bin/google-chrome',
        args: [
            "--disable-gpu",
            "--disable-dev-shm-usage",
            "--disable-setuid-sandbox",
            "--no-sandbox",
        ]
    }); //  тут помекняешь на труе когда все заработает
    const page = await browser.newPage();
    await page.goto('https://business.kazanexpress.ru/');
    await page.waitForSelector('footer');
    const cookies = await page.cookies()
    process.stdout.write(JSON.stringify({ "cookies": cookies.map(c => `${c.name}=${c.value}`).join(";") }));
    await browser.close();
})();



// $output = shell_exec('node run.js');
// echo "<pre>$output</pre>";