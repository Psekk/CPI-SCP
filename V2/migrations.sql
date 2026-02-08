CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" TEXT NOT NULL CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY,
    "ProductVersion" TEXT NOT NULL
);

BEGIN TRANSACTION;
CREATE TABLE "discount" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_discount" PRIMARY KEY AUTOINCREMENT,
    "Code" TEXT NOT NULL,
    "Percentage" decimal(5,2) NOT NULL,
    "ValidUntil" TEXT NOT NULL
);

CREATE TABLE "organization" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_organization" PRIMARY KEY AUTOINCREMENT,
    "Name" TEXT NOT NULL,
    "Email" TEXT NULL,
    "Phone" TEXT NULL,
    "Address" TEXT NULL,
    "City" TEXT NULL,
    "Country" TEXT NULL,
    "CreatedAt" TEXT NOT NULL
);

CREATE TABLE "parking_sessions" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_parking_sessions" PRIMARY KEY AUTOINCREMENT,
    "UserId" INTEGER NOT NULL,
    "VehicleId" INTEGER NOT NULL,
    "LicensePlate" TEXT NULL,
    "StartTime" TEXT NOT NULL,
    "EndTime" TEXT NULL,
    "Cost" decimal(10,2) NULL,
    "ParkingLotId" INTEGER NOT NULL,
    "Status" TEXT NULL
);

CREATE TABLE "payment" (
    "Transaction" TEXT NOT NULL CONSTRAINT "PK_payment" PRIMARY KEY,
    "Amount" decimal(10,2) NOT NULL,
    "Initiator" TEXT NULL,
    "CreatedAt" TEXT NOT NULL,
    "CompletedAt" TEXT NOT NULL,
    "Hash" TEXT NULL,
    "TAmount" decimal(10,2) NOT NULL,
    "TDate" TEXT NOT NULL,
    "Method" TEXT NULL,
    "Issuer" TEXT NULL,
    "Bank" TEXT NULL,
    "ReservationId" TEXT NULL,
    "Status" TEXT NOT NULL
);

CREATE TABLE "reservation" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_reservation" PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "ParkingLotId" INTEGER NOT NULL,
    "VehicleId" INTEGER NOT NULL,
    "StartTime" TEXT NOT NULL,
    "EndTime" TEXT NOT NULL,
    "CreatedAt" TEXT NOT NULL,
    "Status" TEXT NOT NULL,
    "Cost" decimal(10, 2) NOT NULL
);

CREATE TABLE "parking_lot" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_parking_lot" PRIMARY KEY AUTOINCREMENT,
    "Name" TEXT NOT NULL,
    "OrganizationId" INTEGER NULL,
    "Location" TEXT NOT NULL,
    "Address" TEXT NOT NULL,
    "Capacity" INTEGER NOT NULL,
    "Reserved" INTEGER NOT NULL,
    "Tariff" decimal(10,2) NOT NULL,
    "DayTariff" decimal(10,2) NULL,
    "CreatedAt" TEXT NOT NULL,
    "Lat" REAL NOT NULL,
    "Lng" REAL NOT NULL,
    "Status" TEXT NULL,
    "ClosedReason" TEXT NULL,
    "ClosedDate" TEXT NULL,
    CONSTRAINT "FK_parking_lot_organization_OrganizationId" FOREIGN KEY ("OrganizationId") REFERENCES "organization" ("Id") ON DELETE SET NULL
);

CREATE TABLE "user" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_user" PRIMARY KEY AUTOINCREMENT,
    "Username" TEXT NOT NULL,
    "Password" TEXT NOT NULL,
    "Name" TEXT NOT NULL,
    "Email" TEXT NOT NULL,
    "Phone" TEXT NOT NULL,
    "Role" TEXT NOT NULL,
    "OrganizationId" INTEGER NULL,
    "OrganizationRole" TEXT NULL,
    "CreatedAt" TEXT NOT NULL,
    "BirthYear" INTEGER NULL,
    "Active" INTEGER NOT NULL,
    CONSTRAINT "FK_user_organization_OrganizationId" FOREIGN KEY ("OrganizationId") REFERENCES "organization" ("Id") ON DELETE SET NULL
);

CREATE TABLE "vehicle" (
    "Id" INTEGER NOT NULL CONSTRAINT "PK_vehicle" PRIMARY KEY AUTOINCREMENT,
    "UserId" INTEGER NOT NULL,
    "OrganizationId" INTEGER NULL,
    "LicensePlate" TEXT NOT NULL,
    "Make" TEXT NOT NULL,
    "Model" TEXT NOT NULL,
    "Color" TEXT NOT NULL,
    "Year" INTEGER NOT NULL,
    "CreatedAt" TEXT NOT NULL,
    CONSTRAINT "FK_vehicle_organization_OrganizationId" FOREIGN KEY ("OrganizationId") REFERENCES "organization" ("Id") ON DELETE SET NULL
);

CREATE UNIQUE INDEX "IX_discount_Code" ON "discount" ("Code");

CREATE INDEX "IX_organization_CreatedAt" ON "organization" ("CreatedAt");

CREATE UNIQUE INDEX "IX_organization_Name" ON "organization" ("Name");

CREATE INDEX "IX_parking_lot_CreatedAt" ON "parking_lot" ("CreatedAt");

CREATE INDEX "IX_parking_lot_Location" ON "parking_lot" ("Location");

CREATE INDEX "IX_parking_lot_OrganizationId" ON "parking_lot" ("OrganizationId");

CREATE INDEX "IX_parking_sessions_EndTime" ON "parking_sessions" ("EndTime");

CREATE INDEX "IX_parking_sessions_StartTime" ON "parking_sessions" ("StartTime");

CREATE INDEX "IX_parking_sessions_UserId" ON "parking_sessions" ("UserId");

CREATE INDEX "IX_parking_sessions_VehicleId" ON "parking_sessions" ("VehicleId");

CREATE INDEX "IX_payment_ReservationId" ON "payment" ("ReservationId");

CREATE INDEX "IX_reservation_ParkingLotId" ON "reservation" ("ParkingLotId");

CREATE INDEX "IX_reservation_StartTime_EndTime" ON "reservation" ("StartTime", "EndTime");

CREATE INDEX "IX_reservation_UserId" ON "reservation" ("UserId");

CREATE INDEX "IX_reservation_VehicleId" ON "reservation" ("VehicleId");

CREATE INDEX "IX_user_Email" ON "user" ("Email");

CREATE INDEX "IX_user_OrganizationId" ON "user" ("OrganizationId");

CREATE INDEX "IX_vehicle_CreatedAt" ON "vehicle" ("CreatedAt");

CREATE UNIQUE INDEX "IX_vehicle_LicensePlate" ON "vehicle" ("LicensePlate");

CREATE INDEX "IX_vehicle_OrganizationId" ON "vehicle" ("OrganizationId");

CREATE INDEX "IX_vehicle_UserId" ON "vehicle" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260123094450_InitialCreate', '9.0.10');

CREATE TABLE "ef_temp_parking_sessions" (
    "ParkingLotId" INTEGER NOT NULL CONSTRAINT "PK_parking_sessions" PRIMARY KEY AUTOINCREMENT,
    "Cost" decimal(10,2) NULL,
    "EndTime" TEXT NULL,
    "Id" INTEGER NOT NULL,
    "LicensePlate" TEXT NULL,
    "StartTime" TEXT NOT NULL,
    "Status" TEXT NULL,
    "UserId" INTEGER NOT NULL,
    "VehicleId" INTEGER NOT NULL
);

INSERT INTO "ef_temp_parking_sessions" ("ParkingLotId", "Cost", "EndTime", "Id", "LicensePlate", "StartTime", "Status", "UserId", "VehicleId")
SELECT "ParkingLotId", "Cost", "EndTime", "Id", "LicensePlate", "StartTime", "Status", "UserId", "VehicleId"
FROM "parking_sessions";

COMMIT;

PRAGMA foreign_keys = 0;

BEGIN TRANSACTION;
DROP TABLE "parking_sessions";

ALTER TABLE "ef_temp_parking_sessions" RENAME TO "parking_sessions";

COMMIT;

PRAGMA foreign_keys = 1;

BEGIN TRANSACTION;
CREATE INDEX "IX_parking_sessions_EndTime" ON "parking_sessions" ("EndTime");

CREATE INDEX "IX_parking_sessions_StartTime" ON "parking_sessions" ("StartTime");

CREATE INDEX "IX_parking_sessions_UserId" ON "parking_sessions" ("UserId");

CREATE INDEX "IX_parking_sessions_VehicleId" ON "parking_sessions" ("VehicleId");

COMMIT;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260123113345_NEw', '9.0.10');

