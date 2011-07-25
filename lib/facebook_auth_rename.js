module.exports = function(accessToken, accessTokenSecret, facebookMeta) {
  console.log(facebookMeta, '***** fbUserMeta *****');
  return {
      id: facebookMeta.id
    , accessToken: accessToken
    , accessTokenSecret: accessTokenSecret
    , name: facebookMeta.name
    , username: facebookMeta.username
    , picture: 'http://graph.facebook.com/'+facebookMeta.id+'/picture?type=square'
    , gender: facebookMeta.gender
    , email: facebookMeta.email
    , timezone: facebookMeta.timezone
    , locale: facebookMeta.locale
    , verified: facebookMeta.verified
    , updated_time: facebookMeta.updated_time
    , metadata: facebookMeta
  };
};
