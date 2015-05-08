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
#include <dlog.h>
#include <jansson.h>
#include <fprint.h>
#include "XW_Extension.h"
#include "fingerprint.h"

static XW_Extension extension = 0;
static const XW_CoreInterface *core = 0;
static const XW_MessagingInterface *messaging = 0;

struct fp_dscv_dev **discovered_devs = NULL;
struct fp_dev *dev = NULL;

static void instance_created(XW_Instance instance) {
  int res;
  struct fp_dscv_dev *ddev = NULL;
  struct fp_driver *drv = NULL;

  SLOGD("creating instance");

  res = fp_init();
  if (res < 0) {
    SLOGE("libfprint initialization failed");
  }

  discovered_devs = fp_discover_devs();
  if (!discovered_devs) {
    SLOGE("device discovery failed");
  }

  ddev = discovered_devs[0];
  if (!ddev) {
    SLOGE("no devices detected");
  }

  drv = fp_dscv_dev_get_driver(ddev);
  SLOGD("found device - %s", fp_driver_get_full_name(drv));

  dev = fp_dev_open(ddev);
  if (!dev) {
    SLOGE("could not open device");
  }
}

static void instance_destroyed(XW_Instance instance) {
  SLOGD("destroying instance");

  fp_dev_close(dev);
  fp_exit();
}

static void handle_message(XW_Instance instance, const char *msg) {
  json_t *root, *id, *cmd, *res;
  json_error_t err;
  const char *cmd_value;
  char *root_value, *res_value;
  struct fp_img *img;
  struct fp_print_data *print;
  int fp_res;

  SLOGD("received message");

  res = json_object();

  root = json_loads(msg, 0, &err);
  if (!json_is_object(root)) {
    SLOGE("message doesn't appear to be a JSON object");
    goto done;
  }

  root_value = json_dumps(root, 0);
  SLOGD("parsed input: %s", root_value);

  id = json_object_get(root, "id");
  if (!json_is_integer(id)) {
    SLOGE("message id isn't an integer");
    goto done;
  }

  json_object_set(res, "id", id);

  cmd = json_object_get(root, "cmd");
  if (!json_is_string(cmd)) {
    SLOGE("message cmd isn't a string");
    goto done;
  }

  cmd_value = json_string_value(cmd);

  if (strcmp(cmd_value, "scan-finger") == 0) {
    SLOGD("scanning finger");
    json_object_set_new(res, "length", json_integer(1));
    json_object_set_new(res, "0", json_null());
    img = NULL;
    print = NULL;
    do {
      fp_res = fp_enroll_finger_img(dev, &print, &img);
      if (img) {
        fp_img_save_to_file(img, "enrolled.pgm");
        SLOGD("wrote scan to file");
        fp_img_free(img);
      }
      if (fp_res < 0) {
        SLOGE("enroll failed with error %d", fp_res);
      }
      switch (fp_res) {
      case FP_ENROLL_COMPLETE:
        SLOGD("enroll complete");
        break;

      case FP_ENROLL_PASS:
        SLOGD("stage passed");
        break;

      default:
        SLOGE("enrolling failed");
        json_object_set_new(res, "0", json_string("enroll failed"));
      }
    } while (fp_res != FP_ENROLL_COMPLETE);
  } else if (strcmp(cmd_value, "verify-finger") == 0) {
    SLOGD("verifying finger");
    json_object_set_new(res, "length", json_integer(2));
    json_object_set_new(res, "0", json_null());
    json_object_set_new(res, "1", json_boolean(1));
  } else if (strcmp(cmd_value, "delete-finger") == 0) {
    SLOGD("deleting finger");
    json_object_set_new(res, "length", json_integer(1));
    json_object_set_new(res, "0", json_null());
  } else {
    SLOGE("internal JS error: invalid cmd '%s'", cmd_value);
    json_object_set_new(res, "length", json_integer(1));
    json_object_set_new(res, "0", json_string("internal error"));
    goto done;
  }

 done:
  json_decref(root);
  res_value = json_dumps(res, 0);
  SLOGD("posting response: %s", res_value);
  messaging->PostMessage(instance, res_value);
  json_decref(res);
}

static void shutdown(XW_Extension ext) {
  SLOGD("shutting down");
}

int32_t XW_Initialize(XW_Extension ext, XW_GetInterface get_interface) {
  SLOGD("initializing");

  extension = ext;

  core = get_interface(XW_CORE_INTERFACE);
  core->SetExtensionName(ext, LOG_TAG);
  core->SetJavaScriptAPI(ext, kSource_fingerprint);
  core->RegisterInstanceCallbacks(ext, instance_created, instance_destroyed);
  core->RegisterShutdownCallback(ext, shutdown);

  messaging = get_interface(XW_MESSAGING_INTERFACE);
  messaging->Register(ext, handle_message);

  SLOGD("initialization complete");

  return XW_OK;
}
