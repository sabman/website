module.exports = function(accessToken, accessTokenSecret, facebookMeta) {
  return {
      id: facebookMeta.id
    , accessToken: accessToken
    , name: facebookMeta.name
    , username: facebookMeta.username
    , picture: 'http://graph.facebook.com/'+facebookMeta.id+'/picture?type=square'
    , gender: facebookMeta.gender
    , email: facebookMeta.email
    , timezone: facebookMeta.timezone
    , locale: facebookMeta.locale
    , verified: facebookMeta.verified
    , updatedTime: facebookMeta.updatedTime
  };
};
