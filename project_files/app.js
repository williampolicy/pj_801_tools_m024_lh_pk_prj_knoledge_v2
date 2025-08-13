// LIGHT HOPE Project Knowledge Sync System
console.log('LIGHT HOPE PK Sync System v1.0');

document.addEventListener('DOMContentLoaded', function() {
    const statusEl = document.getElementById('status');
    
    // 检查同步状态
    function checkSyncStatus() {
        const lastSync = localStorage.getItem('lastSync');
        if (lastSync) {
            statusEl.textContent = `Last sync: ${new Date(lastSync).toLocaleString()}`;
        } else {
            statusEl.textContent = 'Ready for first sync';
        }
    }
    
    // 模拟同步
    function simulateSync() {
        statusEl.textContent = 'Syncing...';
        setTimeout(() => {
            localStorage.setItem('lastSync', new Date().toISOString());
            statusEl.textContent = 'Sync completed!';
            checkSyncStatus();
        }, 2000);
    }
    
    checkSyncStatus();
    
    // 点击状态区域触发同步
    statusEl.addEventListener('click', simulateSync);
});
