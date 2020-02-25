const lib = require("../config/lib")();
const Api = require("../config/api")();
const auth = require("../config/auth");

var params = {};

describe("User auth", () => {
  const schemaUsersAuthCreate = require("../schema/users/auth/create");
  it("should create admin auth token by login", function(done) {
    Api.post("/users/auth")
      .send({
        login: auth.admin.login,
        password: auth.admin.password
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
          .to.be.jsonSchema(schemaUsersAuthCreate.response);
        done();
      });
  });

  it("should not create admin auth token with wrong password", function(done) {
    Api.post("/users/auth")
      .send({
        login: auth.admin.login,
        password: auth.admin.password + `${Math.random()}`
      })
      .expect("Content-type", /json/)
      .expect(404)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        lib.chai.expect(res.body.error_code).eq("USERS_AUTH_USER_NOT_FOUND");
        done();
      });
  });

  it("should create admin auth token by email", function(done) {
    Api.post("/users/auth")
      .send({
        login: auth.admin.email,
        password: auth.admin.password
      })
      .expect("Content-type", /json/)
      .expect(200)
      .end((err, res) => {
        if (err) {
          done(err);
          return;
        }
        done();
      });
  });

  describe("Token changes", function() {
    before(function(done) {
      auth.authorize("admin", done);
    });

    const schemaUsersAuthShow = require("../schema/users/auth/show");
    it("should show admin auth", function(done) {
      Api.get("/users/auth")
        .set("token", auth.admin.token)
        .expect(200)
        .end((err, res) => {
          if (err) {
            done(err);
            return;
          }
          lib.chai
            .expect(res.body)
            .to.be.jsonSchema(schemaUsersAuthShow.response);
          done();
        });
    });

    it("should delete users auth", function(done) {
      Api.delete("/users/auth")
        .set("token", auth.admin.token)
        .expect(204)
        .end((err, res) => {
          if (err) {
            done(err);
            return;
          }
          done();
        });
    });

    it("should not show admin auth", function(done) {
      Api.get("/users/auth")
        .set("token", auth.admin.token)
        .expect(401)
        .end((err, res) => {
          if (err) {
            done(err);
            return;
          }
          lib.chai.expect(res.body.error_code).eq("USER_TOKEN_NOT_FOUND");
          done();
        });
    });
  });
});
