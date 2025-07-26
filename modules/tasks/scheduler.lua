-- modules/tasks/scheduler.lua
-- Simple cooperative multitasking scheduler

local scheduler = {tasks = {}}

function scheduler.add(fn)
    table.insert(scheduler.tasks, coroutine.create(fn))
end

function scheduler.run()
    while #scheduler.tasks > 0 do
        for i=#scheduler.tasks,1,-1 do
            local co = scheduler.tasks[i]
            if coroutine.status(co) == "dead" then
                table.remove(scheduler.tasks, i)
            else
                local ok, msg = coroutine.resume(co)
                if not ok then print(msg) table.remove(scheduler.tasks, i) end
            end
        end
        os.queueEvent("scheduler_yield")
        os.pullEvent()
    end
end

return scheduler
