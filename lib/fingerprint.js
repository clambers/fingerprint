var callbacks = {
  next_id: 0,
  handlers: {},
  key: 'id',

  setup: function(cb) {
    var id = ++this.next_id;
    this.handlers[id] = cb;
    return id;
  },

  dispatch: function(msg) {
    var id = msg[this.key];
    var handler = this.handlers[id];
    handler.call(null, msg.result);
  }
};

extension.setMessageListener(function(msg) {
  callbacks.dispatch(JSON.parse(msg));
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
}
