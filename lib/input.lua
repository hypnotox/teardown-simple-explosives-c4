function initInput()
    ---@class Input:table
    ---@field esc string Escape key
    ---@field tab string Tab key
    ---@field lmb string Left mouse button
    ---@field rmb string Right mouse button
    ---@field mmb string Middle mouse button
    ---@field upArrow string Up arrow key
    ---@field downArrow string Down arrow key
    ---@field leftArrow string Left arrow key
    ---@field rightArrow string Right arrow key
    ---@field f1 string Function keys
    ---@field f2 string Function keys
    ---@field f3 string Function keys
    ---@field f4 string Function keys
    ---@field f5 string Function keys
    ---@field f6 string Function keys
    ---@field f7 string Function keys
    ---@field f8 string Function keys
    ---@field f9 string Function keys
    ---@field f10 string Function keys
    ---@field f11 string Function keys
    ---@field f12 string Function keys
    ---@field backspace string Backspace key
    ---@field alt string Alt key
    ---@field delete string Delete key
    ---@field home string Home key
    ---@field endKey string End key
    ---@field pgUp string PgUp key
    ---@field pgDown string PgDown key
    ---@field insert string Insert key
    ---@field space string Space bar
    ---@field shift string Shift key
    ---@field ctrl string Ctrl key
    ---@field returnKey string Return key
    ---@field any string Any key or button
    ---@field mouseDx string Mouse horizontal diff. Only valid in InputValue.
    ---@field mouseDy string Mouse vertical diff. Only valid in InputValue.
    ---@field mousewheel string Mouse wheel. Only valid in InputValue.
    ---@field up string Move forward / Accelerate
    ---@field down string Move backward / Brake
    ---@field left string Move left
    ---@field right string Move right
    ---@field interact string Interact
    ---@field flashlight string Flashlight
    ---@field jump string Jump
    ---@field crouch string Crouch
    ---@field usetool string Use tool
    ---@field grab string Grab
    ---@field handbrake string Handbrake
    ---@field map string Map
    ---@field pause string Pause game (escape)
    ---@field cameraX string Camera x movement, scaled by sensitivity. Only valid in InputValue.
    ---@field cameraY string Camera y movement, scaled by sensitivity. Only valid in InputValue.
    Input = {
        esc = 'esc',
        tab = 'tab',
        lmb = 'lmb',
        rmb = 'rmb',
        mmb = 'mmb',
        upArrow = 'uparrow',
        downArrow = 'downarrow',
        leftArrow = 'leftarrow',
        rightArrow = 'rightarrow',
        f1 = 'f1',
        f2 = 'f2',
        f3 = 'f3',
        f4 = 'f4',
        f5 = 'f5',
        f6 = 'f6',
        f7 = 'f7',
        f8 = 'f8',
        f9 = 'f9',
        f10 = 'f10',
        f11 = 'f11',
        f12 = 'f12',
        backspace = 'backspace',
        alt = 'alt',
        delete = 'delete',
        home = 'home',
        endKey = 'end',
        pgUp = 'pgup',
        pgDown = 'pgdown',
        insert = 'insert',
        space = 'space',
        shift = 'shift',
        ctrl = 'ctrl',
        returnKey = 'return',
        any = 'any',
        mouseDx = 'mousedx',
        mouseDy = 'mousedy',
        mousewheel = 'mousewheel',
        up = 'up',
        down = 'down',
        left = 'left',
        right = 'right',
        interact = 'interact',
        flashlight = 'flashlight',
        jump = 'jump',
        crouch = 'crouch',
        usetool = 'usetool',
        grab = 'grab',
        handbrake = 'handbrake',
        map = 'map',
        pause = 'pause',
        cameraX = 'cameraX',
        cameraY = 'cameraY',
    }
end