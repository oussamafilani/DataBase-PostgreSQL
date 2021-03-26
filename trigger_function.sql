CREATE OR REPLACE FUNCTION FunctionALC() RETURNS Trigger AS '
	BEGIN
		NEW.pu := (SELECT pu FROM pdt WHERE no_pdt = NEW.no_pdt);
		NEW.montant := NEW.qte * NEW.pu;
		UPDATE pdt SET stock = stock - NEW.qte WHERE no_pdt = NEW.no_pdt;
		UPDATE commande SET montant = montant + NEW.montant WHERE no_com = NEW.no_cde;
		RETURN NEW;
	END;
' LANGUAGE 'plpgsql';

CREATE TRIGGER AjouterLC
BEFORE INSERT ON ldc
FOR EACH ROW
EXECUTE PROCEDURE FunctionA();

INSERT INTO ldc VALUES (1,4,1,0,0);
INSERT INTO ldc VALUES (1,7,2,0,0);

-- ******************************************** --

CREATE OR REPLACE FUNCTION FunctionM() RETURNS Trigger AS '
	BEGIN
		UPDATE pdt SET stock = stock + (OLD.qte - NEW.qte) WHERE no_pdt = OLD.no_pdt;
		UPDATE ldc SET montant = pu * qte WHERE no_cde = OLD.no_cde;
		RETURN NEW;
	END;
' LANGUAGE 'plpgsql';


CREATE TRIGGER ModifieL
AFTER UPDATE OF qte ON ldc
FOR EACH ROW
EXECUTE PROCEDURE FunctionM();

CREATE OR REPLACE FUNCTION FunctionMM() RETURNS Trigger AS '
	BEGIN
		UPDATE commande SET montant = montant - (OLD.montant - NEW.montant) WHERE no_com = OLD.no_cde;
		RETURN NEW;
	END;
' LANGUAGE 'plpgsql';


CREATE TRIGGER ModifieLM
AFTER UPDATE OF montant ON ldc
FOR EACH ROW
EXECUTE PROCEDURE FunctionMM();

UPDATE ldc SET qte = 1 WHERE no_pdt = 1 AND no_cde = 1;


-- ******************************************** --


CREATE OR REPLACE FUNCTION FunctionSLC() RETURNS Trigger AS '
	BEGIN
		UPDATE pdt SET stock = stock + OLD.qte WHERE no_pdt = OLD.no_pdt;
		UPDATE commande SET montant = montant - OLD.montant WHERE no_com = OLD.no_cde;
		RETURN NEW;
	END;
' LANGUAGE 'plpgsql';


CREATE TRIGGER SupprimeLC
AFTER DELETE ON ldc
FOR EACH ROW
EXECUTE PROCEDURE FunctionSLC();


DELETE FROM ldc WHERE no_pdt = 1 AND no_cde = 1;