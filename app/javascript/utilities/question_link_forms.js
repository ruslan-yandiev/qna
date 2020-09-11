'use strict'

document.addEventListener('turbolinks:load', function () {

    let sum = 0;
    const button = document.querySelector('.button-add-question-link');
    const submit = document.querySelector('#submit-create-ask');
    const RegExp = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/;

    button.addEventListener('click', startClickEvent);
    
    createNewEvent();

    function createNewEvent() {
        document.querySelector(`#question_links_attributes_${sum}_url`).addEventListener('input', startInputEvent);
    };

    function startInputEvent(event) {
        if (RegExp.test(event.target.value)) {
            document.querySelector(`#question_links_attributes_${sum}_url`).removeEventListener('input', startInputEvent);
            sum += 1;
            addFields();
            createNewEvent();
        };
    };

    function startClickEvent(event) {
        sum += 1;
        addFields();
    };

    function addFields() {
        submit.before(createLinkName());
        submit.before(createLinkUrl());
    };

    function createLinkName() {
       let p = document.createElement('p');
       p.insertAdjacentHTML("beforeend", `<label for="question_links_attributes_${sum}_name">Link name</label>`);
       p.insertAdjacentHTML("beforeend", `<input id="question_links_attributes_${sum}_name" type="text" name="question[links_attributes][${sum}][name]">`);
       return p
    };

    function createLinkUrl() {
        let p = document.createElement('p');
        p.insertAdjacentHTML("beforeend", `<label for="question_links_attributes_${sum}_url">Url</label>`);
        p.insertAdjacentHTML("beforeend", `<input id="question_links_attributes_${sum}_url" type="text" name="question[links_attributes][${sum}][url]">`);
        return p
    };
});
