// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import TinymceController from './tinymce/tinymce_controller';

const application = Application.start();
const context = require.context(
  'controllers/backend',
  true,
  /_controller\.js$/
);
application.load(definitionsFromContext(context));
application.register('tinymce', TinymceController);
