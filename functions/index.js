const { onCall } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');

const WOO_URL = defineSecret('WOO_URL');
const WP_USER = defineSecret('WP_USER');
const WP_APP_PASSWORD = defineSecret('WP_APP_PASSWORD');
const WOO_KEY = defineSecret('WOO_KEY');
const WOO_SECRET = defineSecret('WOO_SECRET');

exports.getWooProducts = onCall(
  {
    region: 'us-central1',
    secrets: [WOO_URL, WOO_KEY, WOO_SECRET],
  },
  async (request) => {
    const {
      page = 1,
      perPage = 25,
      status = 'publish',
      categoryIds = [],
    } = request.data;

    let url = `${WOO_URL.value()}/products?page=${page}&per_page=${perPage}&status=${status}`;

    console.log('Resolved WOO_URL:', WOO_URL.value());
    console.log('Final URL:', url);
    console.log('Using WP_USER:', WP_USER.value());
    console.log('Using WP_APP_PASSWORD:', WP_APP_PASSWORD.value());
    console.log('Category IDs:', categoryIds);
    console.log('Page:', page);
    console.log('Per Page:', perPage);
    console.log('Status:', status);

    if (categoryIds.length) {
      url += `&category=${categoryIds.join(',')}`;
    }

    const auth = Buffer.from(
      `${WOO_KEY.value()}:${WOO_SECRET.value()}`
    ).toString('base64');

    const res = await fetch(url, {
      headers: {
        Authorization: `Basic ${auth}`,
        Accept: 'application/json',
      },
    });

    const text = await res.text();

    console.log('Woo status:', res.status);
    console.log('Woo headers:', Object.fromEntries(res.headers.entries()));
    console.log('Woo raw body:', text);

    // 🔥 Protege contra HTML (captcha, WAF, error 403)
    if (!res.ok || text.trim().startsWith('<')) {
      throw new Error(`Woo response invalid (${res.status})`);
    }

    return JSON.parse(text);
  }
);
