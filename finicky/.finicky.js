module.exports = {
  defaultBrowser: "Firefox",
  options: {
    hideIcon: true,
  },
  handlers: [
    {
      match: /^https:\/\/.*\.workdaysuv\.com\/.*$/,
      browser: "Google Chrome",
    },
    {
      // Open any link clicked in Apple Messages, Telegram in Safari
      match: ({ sourceBundleIdentifier }) =>
        ["com.apple.iChat", "ru.keepcoder.Telegram"].includes(
          sourceBundleIdentifier
        ),
      browser: "Safari",
    },
    {
      match: /^https:\/\/.*\.youtube\.com\/.*$/,
      browser: "Safari",
    },
    {
      match: "https://twitter.com/*",
      browser: "Safari",
    },
    {
      match: "https://t.me/*",
      browser: "ru.keepcoder.Telegram",
    },
    {
      match: "https://files-origin.slack.com/*",
      browser: "Firefox",
    },
  ],
  rewrite: [
    {
      match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
      url({ url }) {
        const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
        const removeKeys = ["fbclid", "gclid"]; // Remove all query parameters matching these keys

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(
            ([key]) =>
              !removeKeysStartingWith.some((startingWith) =>
                key.startsWith(startingWith)
              )
          )
          .filter(
            ([key]) => !removeKeys.some((removeKey) => key === removeKey)
          );

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    },
  ],
};
