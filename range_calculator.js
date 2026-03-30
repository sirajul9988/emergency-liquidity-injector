/**
 * Utility to calculate V3 tick ranges based on a percentage offset 
 * from the current price. 
 */
function getTicksForRange(currentTick, percentOffset) {
    const tickSpacing = 60; // For 0.3% pools
    const offset = Math.floor(percentOffset * 100); // Rough approximation
    
    const lower = Math.floor((currentTick - offset) / tickSpacing) * tickSpacing;
    const upper = Math.floor((currentTick + offset) / tickSpacing) * tickSpacing;

    return { tickLower: lower, tickUpper: upper };
}

const { tickLower, tickUpper } = getTicksForRange(-20000, 0.05); // 5% range
console.log(`Current Tick: -20000 | Support Range: ${tickLower} to ${tickUpper}`);
