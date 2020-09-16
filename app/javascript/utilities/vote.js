'use strict'

document.addEventListener('turbolinks:load', function () {
    document.body.addEventListener('ajax:success', (event) => {
        const votes = event.detail[0].votes,
              classType = votes[0].voteable_type,
              objectID = votes[0].voteable_id;

        let likes = 0;

        votes.forEach((element) => { likes += element.value });

        document.querySelector(`#vote-${classType}-${objectID} .like`).innerHTML = likes
    });
});