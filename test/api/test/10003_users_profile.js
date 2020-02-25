const lib = require("../config/lib")();
const Api = require("../config/api")();
const auth = require("../config/auth");

var params = {
  first_name: `TestFirstName${+new Date()}`,
  last_name: `TestLastName${+new Date()}`
};

describe("User profile", () => {
  before(function(done) {
    auth.authorize("admin", done);
  });

  const schemaUsersProfileShow = require("../schema/users/profile/show");
  it("should show users profile", function(done) {
    Api.get("/users/profile")
      .set("token", auth.admin.token)
      .expect("Content-type", /json/)
      .expect(200)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        lib.chai
          .expect(res.body)
          .to.be.jsonSchema(schemaUsersProfileShow.response);
        lib.chai.expect(res.body.login).eq(auth.admin.login);
        lib.chai.expect(res.body.email).eq(auth.admin.email);
        done();
      });
  });

  it("should update users profile", function(done) {
    Api.put("/users/profile")
      .set("token", auth.admin.token)
      .send({
        first_name: params.first_name,
        last_name: params.last_name
      })
      .expect("Content-type", /json/)
      .expect(200)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        lib.chai
          .expect(res.body)
          .to.be.jsonSchema(schemaUsersProfileShow.response);
        lib.chai.expect(res.body.first_name).eq(params.first_name);
        lib.chai.expect(res.body.last_name).eq(params.last_name);
        done();
      });
  });
});
