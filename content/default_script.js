// ---------- boot sequence ----------
const bootLines = [
    {text:"> establishing uplink...", cls:"amber"},
    {text:"> handshake failed. retrying...", cls:"corrupt"},
    {text:"> partial signal acquired [SIGNAL_09]", cls:"amber"},
    {text:"> integrity check: 3 fragments detected, 3 corrupted", cls:"corrupt"},
    {text:"> recommend manual decryption. good luck, investigator.", cls:"amber"},
];

const bootEl = document.getElementById('bootText');

let lineIdx = 0, charIdx = 0;

function typeBoot(){
    if(lineIdx >= bootLines.length){
        bootEl.innerHTML += '<span class="caret">&nbsp;</span>';
        return;
    }

    const current = bootLines[lineIdx];

    if(charIdx === 0){
        bootEl.innerHTML += '<span class="' + current.cls + '">';
    }

    if(charIdx < current.text.length){
        const span = bootEl.querySelectorAll('span.' + current.cls);
        span[span.length-1].textContent += current.text[charIdx];
        charIdx++;
        setTimeout(typeBoot, 14 + Math.random()*18);
    } else {
        bootEl.innerHTML += '</span>\n';
        lineIdx++; charIdx = 0;
        setTimeout(typeBoot, 220);
    }
}

typeBoot();