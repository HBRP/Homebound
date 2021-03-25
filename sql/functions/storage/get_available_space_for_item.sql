CREATE OR REPLACE FUNCTION "storage".get_available_space_for_item(storage_id int4, item_id int4)
    RETURNS int4
    LANGUAGE plpgsql
AS $function$
    DECLARE 
        check_slot int4;
        max_slots  int4;
        slot_temp  int4;
        max_items_in_slot int4;
        amount_can_insert int4;
    BEGIN
        check_slot := 1;
        amount_can_insert := 0;

        CREATE TEMP TABLE slot_ids(
            Slot INTEGER NOT NULL,
            SpaceLeft INTEGER NOT null,
            ItemId INTEGER NOT null
        );

        SELECT
            II.ItemMaxStack INTO max_items_in_slot
            FROM Item.Items II
            WHERE II.ItemId = item_id;

        SELECT 
            ST.StorageTypeSlots INTO max_slots 
            FROM Storage.Containers SC 
            INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId 
            WHERE SC.StorageId = storage_id
            LIMIT 1;

        INSERT INTO slot_ids 
        SELECT SI.Slot, (max_items_in_slot - SI.Amount), SI.ItemId as SpaceLeft FROM Storage.Items SI
        WHERE 
                SI.StorageId = storage_id
            and SI.Empty     ='f';

        SELECT SUM(SpaceLeft) INTO amount_can_insert FROM slot_ids where itemId = item_id;
        
        if amount_can_insert is null then
            amount_can_insert := 0;
        end if;
       
        LOOP
            SELECT Slot INTO slot_temp FROM slot_ids WHERE Slot = check_slot LIMIT 1;
            IF slot_temp IS NULL then
                amount_can_insert := amount_can_insert + max_items_in_slot;
            END IF;
        
            check_slot := check_slot + 1;
            
            IF check_slot > max_slots then
                DROP TABLE slot_ids;
                RETURN amount_can_insert;
                EXIT;
            END IF;
        END LOOP;
    END;
$function$;
