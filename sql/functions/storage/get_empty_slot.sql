CREATE OR REPLACE FUNCTION "storage".get_empty_slot(storage_id int4)
    RETURNS int4
    LANGUAGE plpgsql
AS $function$
    DECLARE 
        check_slot int4;
        max_slots  int4;
        slot_temp  int4;
    BEGIN
        check_slot := 1;
        CREATE TEMP TABLE slot_ids(
            Slot INTEGER NOT NULL
        );

        INSERT INTO slot_ids 
        SELECT SI.Slot FROM Storage.Items SI
        WHERE SI.StorageId = storage_id and SI.deleted ='f';

        SELECT 
            ST.StorageTypeSlots INTO max_slots 
            FROM Storage.Containers SC 
            INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId 
            WHERE SC.StorageId = storage_id
            LIMIT 1;
        
        LOOP
            SELECT Slot INTO slot_temp FROM slot_ids WHERE Slot = check_slot LIMIT 1;
            IF slot_temp IS NULL then
                DROP TABLE slot_ids;
                RETURN check_slot;
                EXIT;
            END IF;
        
            check_slot := check_slot + 1;
            
            IF check_slot > max_slots then
                DROP TABLE slot_ids;
                RETURN -1;
                EXIT;
            END IF;
        END LOOP;
    END;
$function$;
