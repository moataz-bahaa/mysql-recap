-- event: a task (or block of sql code) that gets excuted according to a schedule
SHOW VARIABLES LIKE 'event%';
SET GLOBAL event_scheduler = ON;

DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
	-- AT '2022-05-01' -- excutes only one time
    EVERY 1 YEAR STARTS '2022-10-26' ENDS '2029-01-01' -- starts and ends is optional
DO BEGIN
	DELETE FROM payments_audit
	WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$
    
DELIMITER ;


SHOW EVENTS;
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;


-- ALTER EVENT for updating an existing event or for disabling or enabling an event
ALTER EVENT yearly_delete_stale_audit_rows DISABLE;