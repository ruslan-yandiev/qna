'use strict'

document.addEventListener('turbolinks:load', function () {

    let sum = 0;
    let answerIdNumber;

    document.querySelector('.answers').addEventListener('click', (event) => {
        if (event.target.className === 'edit-answer-link') {
            answerIdNumber = event.explicitOriginalTarget.dataset.answerId;

            document.querySelector(`.button-edit-answer-link-${answerIdNumber}`).addEventListener('click', (event) => {
                const submit = document.querySelector(`#submit-edit-answer-${answerIdNumber}`);
                sum += 1;
                submit.before(createLinkName());
                submit.before(createLinkUrl());
            });
        };
    });

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
