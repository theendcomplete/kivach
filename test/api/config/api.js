const lib = require("./lib")();

module.exports = () => {
  const API_URL = lib.process.env.API_URL || "http://localhost:3000";
  if (!API_URL) {
    console.error("Please set API_URL");
    return;
  }
  const Api = lib.supertest.agent(lib.url.resolve(API_URL, "/api/v1"));

  if (lib.process.env.API_KEY) {
    Api.set("apikey", lib.process.env.API_KEY);
  }
  return Api;
};
