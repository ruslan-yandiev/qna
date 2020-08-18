'use strict'

document.addEventListener('turbolinks:load', function () {

    document.querySelector('.question').addEventListener('click', (event) => {

        if (event.target.className === 'edit-question-link') {
            event.preventDefault();

            let form = document.querySelector('#edit-question');
            event.target.hidden = true;
            form.className = '';

            form.addEventListener('submit', () => {
                form.className = 'hidden';
                event.target.hidden = false;
            });
        }
    });
});
