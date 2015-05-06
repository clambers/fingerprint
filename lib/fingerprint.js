(function() {
  var callbacks = {
    nextId: 0,
    handlers: {},
    key: 'id',

    setup: function(cb) {
      var id = ++this.nextId;
      this.handlers[id] = cb;
      return id;
    },

    dispatch: function(res) {
      var id = res[this.key];
      var handler = this.handlers[id];
      delete res.id;
      handler.apply(null, Array.prototype.slice.call(res));
    }
  };

  extension.setMessageListener(function(msg) {
    var res = JSON.parse(msg);
    callbacks.dispatch(res);
  });

  function postMessage(id, msg) {
    if (id !== undefined && id !== null) {
      msg[callbacks.key] = id;
    }
    extension.postMessage(JSON.stringify(msg));
  }

  exports.scanFinger = function(name, gender, fingerType, cb) {
    var id = callbacks.setup(cb);
    var msg = { cmd: 'scan-finger' };
    postMessage(id, msg);
  };

  exports.verifyFinger = function(name, gender, cb) {
    var id = callbacks.setup(cb);
    var msg = { cmd: 'verify-finger' };
    postMessage(id, msg);
  };

  exports.deleteFinger = function(name, gender, fingerType, categoryType, cb) {
    var id = callbacks.setup(cb);
    var msg = { cmd: 'delete-finger' };
    postMessage(id, msg);
  };
})();
