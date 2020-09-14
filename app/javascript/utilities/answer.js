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
        // let xhr = event.detail[2];
        // возьмем распарсеный объект json, чтобы избежать шага парсинга его из текста тут
        let json = event.detail[0];

        // далее из объекта промиса извлечем наш не распарсеный html в виде строки и сразу добавим в наш DOMhtml element
        // answers.append(xhr.responseText); // почему то не корректно работает
        // answers.insertAdjacentHTML("beforeend", xhr.responseText);

        // answers.append('<p>' + json.body + '</p>');
        answers.insertAdjacentHTML("beforeend", '<p>' + json.body + '</p>');
    });

    answerCreate.addEventListener('ajax:error', (event) => {
        let answerErrors = document.querySelector('.answer-errors');

        // let xhr = event.detail[2];
        let jsonArrayErrors = event.detail[0];

        jsonArrayErrors.forEach(error => {
            // answerErrors.append('<p>' + error + '</p>');
            answerErrors.insertAdjacentHTML("beforeend", '<p>' + error + '</p>');
        });

        // answerErrors.innerHTML = xhr.responseText;
    });
});