var info;
var size = {};
var show = true;
var titlesize = 2.25;
var playerSize = 1.6;
var playerSizeme = 1.83;

document.onkeydown = (e) =>{
    const key = e.key;
    if (key == "Escape"){
        $('.settings-wrap').slideUp()
        $.post("http://qb-10system/close", JSON.stringify({}));
    }
};
$(".header").on("click",".header-txt",function(){
    if(show){
        $("#open").hide();
        $("#close").show();
    }else{
        $("#close").hide();
        $("#open").show();
    }
    $('.settings-wrap').slideDown();
})

$(".settings-wrap").on("click",".update-btn",function(){
    var code = $('#code').val();
    var object = {};
    if(code != "") object.code = code;
    $.post("http://qb-10system/gradeCode",JSON.stringify(object));
})
$(".settings-wrap").on("click",".show",function(){
    if(show){
        show = false;
        $.post("http://qb-10system/closeActive",JSON.stringify({}));
        $(".systyem-wrap").fadeOut();
        $("#close").hide();
        $("#open").show();
    }else{
        show = true;
        $.post("http://qb-10system/openActive",JSON.stringify({}));
        $(".systyem-wrap").fadeIn();
        $("#close").show();
        $("#open").hide();
    }
})
DragAble();
$(document).on('input change', '#increase-size', function() {
    size.size =  $(this).val();
    size.me = Math.abs(playerSizeme * $(this).val());
    size.title =  Math.abs(titlesize * $(this).val());
    size.player = Math.abs(playerSize * $(this).val());
    
    $('.header').css('font-size', `${size.title}rem`);
    $('.officers me').css('font-size', `${size.me}rem`);
    $('.officers').css('font-size', `${size.player}rem`);
    $('.officers me').css('font-weight','bold');
});


function DragAble(){
    $( ".systyem-wrap" ).draggable({
        appendTo: 'body',
        containment: 'window',
        scroll: false,
    });
}

window.addEventListener('message', event =>{
    if(event.data.action == "update"){
        ActiveOfficers(event)
        $( ".systyem-wrap" ).fadeIn()
    }else if(event.data.action == "hide"){
        $( ".systyem-wrap" ).fadeOut()
    }else if(event.data.action == "settings"){
        if(show){
            $("#open").hide();
            $("#close").show();
        }else{
            $("#close").hide();
            $("#open").show();
        }
        $('.settings-wrap').slideDown();

    }
})

ActiveOfficers = (event) => {
    let arr = [];
    $('.systyem-container').html("");
    let officers = event.data.data;

    for(let key in officers)
      arr[arr.length] = officers[key];
    arr.sort((a, b) => a.code-b.code);

    let me = arr.filter(m => m.me)[0];

    for(let i = 0; i < arr.length; i++){
        player = arr[i]
        $('.header-txt').text(`Active Officers - (${i + 1})`)
        if(player != null) {
            var html;
            if (player.me){
                    html = `
                    <div class="officers me">
                        <span class="tag" style="background-color: ${getColorBasedOnRank(parseInt(player.code))};">${player.code}</span>${player.name} | ${player.grade} - <span style="color: ${(player.talking && player.channel == me.channel) ? "red" : "rgb(255, 255, 255)"}; font-weight: bold;" class="radioChannel">${player.channel != -1 && player.channel != null ? player.channel : "x"} Hz</span></span>
                    </div>`
                $('.systyem-container').append(html);
            }else {
                    html = `
                    <div class="officers">
                        <span class="tag" style="background-color: ${getColorBasedOnRank(parseInt(player.code))};">${player.code}</span>${player.name} | ${player.grade} - <span style="color: ${(player.talking && player.channel == me.channel) ? "red" : "rgb(255, 255, 255)"}; font-weight: bold;" class="radioChannel">${player.channel != -1 && player.channel != null ? player.channel : "x"} Hz</span></span>
                    </div>`
                $('.systyem-container').append(html);
            }
            $('.officers').css('font-size', `${size.player}rem`);
        }
    }
}

const colorOptions = {
    "200-209": "#e60000",
    "210-279": "#4165a3",
    "280-289": "#252526",
    "290-299": "#c2c2c2",
    "400-499": "#a5810c",
    "280-289": "#000000f5",
    "300-399": "#0000ff"
}

function getColorBasedOnRank(rank) {
    if(rank == null) return "#FFFFFF";
    for(let key in colorOptions) {
        let range = key.split("-");
        if(rank >= range[0] && rank <= range[1])
            return colorOptions[key];
    }
}