'use strict'

document.addEventListener('turbolinks:load', function () {
    
    document.querySelector('.answers').addEventListener('click', (event) => {

        if (event.target.className === 'edit-answer-link') {
            event.preventDefault();

            let form = document.querySelector(`#edit-answer-${event.target.dataset.answerId}`);
            event.target.hidden = true;
            form.className = '';

            form.addEventListener('submit', () => {
                form.className = 'hidden';
                event.target.hidden = false;
            });
        }
    });
});