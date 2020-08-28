'use strict'

document.addEventListener('turbolinks:load', function () {

    let sum = 0;
    const submit = document.querySelector('#submit-create-answer');
    const RegExp = /^((ftp|http|https):\/\/)?(www\.)?([A-Za-zА-Яа-я0-9]{1}[A-Za-zА-Яа-я0-9\-]*\.?)*\.{1}[A-Za-zА-Яа-я0-9-]{2,8}(\/([\w#!:.?+=&%@!\-\/])*)?/;

    createNewEvent();

    function createNewEvent() {
        document.querySelector(`#answer_links_attributes_${sum}_url`).addEventListener('input', startEvent);
    };

    function startEvent(event) {
        if (RegExp.test(event.target.value)) {
            document.querySelector(`#answer_links_attributes_${sum}_url`).removeEventListener('input', startEvent);
            sum += 1;
            addFields();
            createNewEvent();
        };
    };


    function addFields() {
        submit.before(createLinkName());
        submit.before(createLinkUrl());
    };

    function createLinkName() {
        let p = document.createElement('p');
        p.insertAdjacentHTML("beforeend", `<label for="answer_links_attributes_${sum}_name">Link name</label>`);
        p.insertAdjacentHTML("beforeend", `<input id="answer_links_attributes_${sum}_name" type="text" name="answer[links_attributes][${sum}][name]">`);
        return p
    };

    function createLinkUrl() {
        let p = document.createElement('p');
        p.insertAdjacentHTML("beforeend", `<label for="answer_links_attributes_${sum}_url">Url</label>`);
        p.insertAdjacentHTML("beforeend", `<input id="answer_links_attributes_${sum}_url" type="text" name="answer[links_attributes][${sum}][url]">`);
        return p
    };
});
