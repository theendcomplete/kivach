const lib = require("../config/lib")();
const Api = require("../config/api")();
const auth = require("../config/auth");

var params = {};

describe("Errors", function() {
  const schemaError = require("../schema/error");
  it("should show error", function(done) {
    Api.get("/")
      .expect(404)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        lib.chai.expect(res.body).to.be.jsonSchema(schemaError.response);
        done();
      });
  });
});
