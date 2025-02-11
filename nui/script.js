const scoreboard = $('#scoreboard');

window.addEventListener('message', function (event) {
    if (event.data.type === 'show') {
        scoreboard.css('width', '28vh');
        scoreboard.css('height', '16vh');
    }
    else if (event.data.type === 'hide') {
        scoreboard.css('width', '0%');
        scoreboard.css('height', '0%');
    }
    else if (event.data.type === 'update') {
        if (event.data.data.target === 'total')
        {
            $('#players-count').text(event.data.data.value);
        }
        else if (event.data.data.target === 'jobs') 
        {
            $('#LSC-count').text(event.data.data.value['mechanic']);
            $('#LSPD-count').text(event.data.data.value['police']);
            $('#EMS-count').text(event.data.data.value['ambulance']);
        }
        else if (event.data.data.target === 'currentjob')
        {
            $('#currentjob-title').text(event.data.data.value);
        }
    }
    else if (event.data.updatedColors)
    {
        $(':root').css('--main', event.data.updatedColors.mainColor);
        $(':root').css('--secondary', event.data.updatedColors.secondaryColor);
        $(':root').css('--background', event.data.updatedColors.backgroundColor);
    }
});