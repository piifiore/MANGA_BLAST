function rimuoviPreferito(id, tipo) {
    fetch('RimuoviPreferitoServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ id, tipo })
    })
        .then(() => {
            mostraBanner("🗑️ Rimosso dai preferiti!");
            setTimeout(() => location.reload(), 1000);
        });
}

function mostraBanner(msg) {
    let banner = document.createElement('div');
    banner.textContent = msg;
    banner.style.position = 'fixed';
    banner.style.top = '10px';
    banner.style.right = '10px';
    banner.style.background = '#9C27B0';
    banner.style.color = '#fff';
    banner.style.padding = '10px 20px';
    banner.style.fontWeight = 'bold';
    banner.style.borderRadius = '5px';
    banner.style.zIndex = '1000';
    banner.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
    document.body.appendChild(banner);
    setTimeout(() => banner.remove(), 2000);
}