/* Copyright (C) 2015 Jaguar Land Rover Automotive PLC.

   This file is part of Fingerprint.

   Fingerprint is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Fingerprint is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with Fingerprint.  If not, see <http://www.gnu.org/licenses/>. */

#define LOG_TAG "fingerprint"

#include <stdlib.h>
#include <string.h>
#include <dlog/dlog.h>
#include <jansson.h>
#include <fprint.h>
#include "XW_Extension.h"
#include "fingerprint.h"

static XW_Extension extension = 0;
static const XW_CoreInterface *core = 0;
static const XW_MessagingInterface *messaging = 0;

static void instance_created(XW_Instance instance) {
  SLOGI("creating instance");
}

static void instance_destroyed(XW_Instance instance) {
  SLOGI("destroying instance");
}

static void handle_message(XW_Instance instance, const char *msg) {
  json_t *root, *id, *cmd, *res, *rel;
  json_error_t err;
  const char *cmd_value, *rel_value;
  char *root_value, *res_value, *path_value;

  SLOGI("received message");

  res = json_object();

  root = json_loads(msg, 0, &err);
  if (!json_is_object(root)) {
    SLOGE("message doesn't appear to be a JSON object");
    goto done;
  }

  root_value = json_dumps(root, 0);
  SLOGI("parsed input: %s", root_value);

  id = json_object_get(root, "id");
  if (!json_is_integer(id)) {
    SLOGE("message id isn't an integer");
    goto done;
  }

  json_object_set(res, "id", id);
  json_object_set_new(res, "result", json_string("internal error"));

  cmd = json_object_get(root, "cmd");
  if (!json_is_string(cmd)) {
    SLOGE("message cmd isn't a string");
    goto done;
  }

  cmd_value = json_string_value(cmd);

  if (strcmp(cmd_value, "get-version") == 0) {} else {
    SLOGE("internal JS error: invalid cmd '%s'", cmd_value);
    goto done;
  }

 done:
  json_decref(root);
  res_value = json_dumps(res, 0);
  SLOGI("posting response: %s", res_value);
  messaging->PostMessage(instance, res_value);
  json_decref(res);
}

static void shutdown(XW_Extension ext) {
  SLOGI("shutting down");
}

int32_t XW_Initialize(XW_Extension ext, XW_GetInterface get_interface) {
  SLOGI("initializing");

  extension = ext;

  core = get_interface(XW_CORE_INTERFACE);
  core->SetExtensionName(ext, LOG_TAG);
  core->SetJavaScriptAPI(ext, kSource_fingerprint);
  core->RegisterInstanceCallbacks(ext, instance_created, instance_destroyed);
  core->RegisterShutdownCallback(ext, shutdown);

  messaging = get_interface(XW_MESSAGING_INTERFACE);
  messaging->Register(ext, handle_message);

  SLOGI("initialization complete");

  return XW_OK;
}
