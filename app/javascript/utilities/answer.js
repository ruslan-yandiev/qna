'use strict'

document.addEventListener('turbolinks:load', function () {
    const answers = document.querySelector('.answers');
    const answerCreate = document.querySelector('.answer-create');
    
    answers.addEventListener('click', (event) => {

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

    // Повесим обработчики событий на формы по созданию вопроса и события успешного и не успешного ajax:
    answerCreate.addEventListener('ajax:success', (event) => {
        // из события извлечем объект Промиса 
        let xhr = event.detail[2];

        // далее из объекта промиса извлечем наш не распарсеный html в виде строки и сразу добавим в наш DOMhtml element
        // answers.append(xhr.responseText); // почему то не корректно работает
        answers.insertAdjacentHTML("beforeend", xhr.responseText);
    });

    answerCreate.addEventListener('ajax:error', (event) => {
        let xhr = event.detail[2];

        document.querySelector('.answer-errors').innerHTML = xhr.responseText;
    });
});