// This app does not use the asset pipeline.
//
// It uses webpack to manage front-end code.

// We need to import the CSS so that webpack will load it.
// The ExtractTextPlugin is used to separate it out into
// its own CSS file.
import css from '../stylesheets/application.scss';

import 'jquery-ujs';
import '../../../node_modules/bootstrap-sass/assets/javascripts/bootstrap';

import { Elm } from '../elm/Question.elm';

document.addEventListener('DOMContentLoaded', function (event) {
  var csrfTokenNode = document.head.querySelector('meta[name="csrf-token"]');
  var csrfToken =
    csrfTokenNode === null || typeof csrfTokenNode.content !== 'string'
      ? null
      : csrfTokenNode.content;

  const node = document.getElementById('question');

  if (node !== null) {
    Elm.Question.init({
      node,
      flags: {
        csrfToken: csrfToken,
        questions: JSON.parse(node.dataset.questions),
        status: JSON.parse(node.dataset.status),
      },
    });
  }
});
