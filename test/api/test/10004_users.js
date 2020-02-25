const lib = require("../config/lib")();
const Api = require("../config/api")();
const auth = require("../config/auth");

var params = {};

describe("Users", () => {
  before(function(done) {
    auth.authorize("admin", done);
  });

  const schemaUsersIndex = require("../schema/users/index");
  it("should index users", function(done) {
    Api.get("/users")
      .set("token", auth.admin.token)
      .expect("Content-type", /json/)
      .expect(200)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        lib.chai.expect(res.body).to.be.jsonSchema(schemaUsersIndex.response);
        done();
      });
  });
});
