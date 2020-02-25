module.exports = () => {
  const chai = require("chai");
  chai.use(require("chai-json-schema"));

  return {
    process: process,
    chai: chai,
    url: require("url"),
    supertest: require("supertest"),
    expect: require("unexpected")
  };
};
