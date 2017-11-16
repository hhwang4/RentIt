from __future__ import print_function
import json
import sys

def find_tool(params):
    mapping = {
        'Screwdriver': Screwdriver,
        'Socket': Socket,
        'Ratchet': Ratchet,
        'Wrench': Wrench,
        'Pliers': Pliers,
        'Gun': Gun,
        'Hammer': Hammer,
        'Digger': Digger,
        'Pruner': Pruner,
        'Rakes': Rakes,
        'WheelBarrows': WheelBarrows,
        'Striking': Striking,
        'Straight': Straight,
        'Step': Step,
        'Drill': Drill,
        'Saw': Saw,
        'Sander': Sander,
        'Air-Compressor': AirCompressor,
        'Mixer': Mixer,
        'Generator': Generator
    }
    sub_type = params['sub_type']['name']
    return mapping[sub_type](params)

class Tool(object):
    def __init__(self, params):
        self.category = params['category']
        self.sub_type = params['sub_type']
        self.sub_option = params['sub_option']
        self.width = float(params['width'])
        self.length = float(params['length'])
        self.weight = float(params['weight'])
        self.manufacturer = params['manufacturer']
        self.material = params['material']
        self.power_source = params['power_source']
        self.original_price = float(params['original_price'])

    def create(self, cursor):
        result = cursor.execute("INSERT INTO Tool (width, weight, length, manufacturer, material, deposit_price, rental_price,\
            original_price, Category_Id, PowerSource_Id, SubOption_Id, SubType_Id) \
            VALUES (%s, %s, %s, %s, %s, %s,%s, %s, %s, %s, %s, %s)",
            [self.width, self.weight, self.length, self.manufacturer, self.material,
             self.original_price * .4, self.original_price * .15, self.original_price,
             self.category['id'], self.power_source['id'], self.sub_option['id'], self.sub_type['id']])
        assert cursor.rowcount == 1, 'Failed INSERT, Affected row: %d' % cursor.rowcount
        cursor.execute("SELECT last_insert_id()")
        self.tool_id = cursor.fetchone()[0]
        return self

class Hand(Tool):
    def __init__(self, params):
        super(Hand, self).__init__(params)

    def create(self, cursor):
        super(Hand, self).create(cursor)
        cursor.execute("INSERT INTO HandTool VALUES (%s)", [self.tool_id])
        assert cursor.rowcount == 1, 'Failed INSERT, Affected row: %d' % cursor.rowcount
        return self

class Screwdriver(Hand):
    def __init__(self, params):
        super(Screwdriver, self).__init__(params)
        self.screw_size = int(params['screw_size'])

    def create(self, cursor):
        super(Screwdriver, self).create(cursor)
        cursor.execute("INSERT INTO ScrewDriver VALUES (%s, %s)", [self.tool_id, self.screw_size])
        return self

class Socket(Hand):
    def __init__(self, params):
        super(Socket, self).__init__(params)
        self.drive_size = float(params['socket_drive_size'])
        self.sae_size = float(params['socket_sae_size'])

    def create(self, cursor):
        super(Socket, self).create(cursor)
        cursor.execute("INSERT INTO HandSocket VALUES (%s, %s, %s, %s)", [self.tool_id, self.drive_size, self.sae_size, 1 if self.sub_option == 'deep' else 0])
        return self

class Ratchet(Hand):
    def __init__(self, params):
        super(Ratchet, self).__init__(params)
        self.drive_size = float(params['rachet_drive_size'])

    def create(self, cursor):
        super(Ratchet, self).create(cursor)
        cursor.execute("INSERT INTO HandRatchet VALUES (%s, %s)", [self.tool_id, self.drive_size])
        return self

class Wrench(Hand):
    def __init__(self, params):
        super(Wrench, self).__init__(params)
        self.drive_size = params['wrench_drive_size']

    def create(self, cursor):
        super(Wrench, self).create(cursor)
        cursor.execute("INSERT INTO HandWrench VALUES (%s, %s)", [self.tool_id, self.drive_size])
        return self

class Pliers(Hand):
    def __init__(self, params):
        super(Pliers, self).__init__(params)
        self.adjustable = params['pliers_adjustable']

    def create(self, cursor):
        super(Pliers, self).create(cursor)
        cursor.execute("INSERT INTO HandPlier VALUES (%s, %s)", [self.tool_id, self.adjustable])
        return self

class Gun(Hand):
    def __init__(self, params):
        super(Gun, self).__init__(params)
        self.gauge_rating = int(params['gun_gauge_rating'])
        self.capacity = int(params['gun_capacity'])

    def create(self, cursor):
        super(Gun, self).create(cursor)
        cursor.execute("INSERT INTO HandGun VALUES (%s, %s, %s)", [self.tool_id, self.capacity])
        return self

class Hammer(Hand):
    def __init__(self, params):
        super(Hammer, self).__init__(params)
        self.anti_vibration = params['hammer_anti_vibration']

    def create(self, cursor):
        super(Hammer, self).create(cursor)
        cursor.execute("INSERT INTO HandHammer VALUES (%s, %s)", [self.tool_id, self.anti_vibration])
        return self

class Garden(Tool):
    def __init__(self, params):
        super(Garden, self).__init__(params)
        self.handle_material = params['handle_material']

    def create(self, cursor):
        super(Garden, self).create(cursor)
        cursor.execute("INSERT INTO GardenTool VALUES (%s, %s)", [self.tool_id, self.handle_material])
        return self

class Pruner(Garden):
    def __init__(self, params):
        super(Pruner, self).__init__(params)
        self.blade_material = params['pruner_blade_material']
        self.blade_length = float(params['pruner_blade_length'])

    def create(self, cursor):
        super(Pruner, self).create(cursor)
        cursor.execute("INSERT INTO PrunningTool VALUES (%s, %s, %s)", [self.tool_id, self.blade_material, self.blade_length])
        return self

class Striking(Garden):
    def __init__(self, params):
        super(Striking, self).__init__(params)
        self.head_weight = float(params['striking_head_weight'])

    def create(self, cursor):
        super(Striking, self).create(cursor)
        cursor.execute("INSERT INTO StrikingTool VALUES (%s, %s)", [self.tool_id, self.head_weight])
        return self

class Digger(Garden):
    def __init__(self, params):
        super(Digger, self).__init__(params)
        self.blade_width = float(params['digger_blade_width'])
        self.blade_length = float(params['digger_blade_length'])

    def create(self, cursor):
        super(Digger, self).create(cursor)
        cursor.execute("INSERT INTO DiggingTool VALUES (%s, %s, %s)", [self.tool_id, self.blade_width, self.blade_length])
        return self

class Rakes(Garden):
    def __init__(self, params):
        super(Rakes, self).__init__(params)
        self.tine_count = int(params['rakes_tine_count'])

    def create(self, cursor):
        super(Rakes, self).create(cursor)
        cursor.execute("INSERT INTO RakeTool VALUES (%s, %s)", [self.tool_id, self.tine_count])
        return self

class WheelBarrows(Garden):
    def __init__(self, params):
        super(WheelBarrows, self).__init__(params)
        self.bin_material = params['wheelbarrow_bin_material']
        self.wheel_count = int(params['wheelbarrow_wheel_count'])
        self.bin_volume = params['wheelbarrow_bin_volume']

    def create(self, cursor):
        super(WheelBarrows, self).create(cursor)
        cursor.execute("INSERT INTO WheelBarrowTool \
                       VALUES (%s, %s, %s, %s)", [self.tool_id, self.bin_material, self.wheel_count, self.bin_volume])
        return self

class Power(Tool):
    def __init__(self, params):
        super(Power, self).__init__(params)
        self.volt_rating = float(params['power_volt_rating'])
        self.amp_rating = float(params['power_amp_rating'])
        self.min_rpm_rating = float(params['power_min_rpm_rating'])
        self.max_rpm_rating = float(params['power_max_rpm_rating'])
        self.accessories = params['accessories']

    def create(self, cursor):
        super(Power, self).create(cursor)
        cursor.execute("INSERT INTO PowerTool VALUES (%s, %s, %s, %s, %s)",
                       [self.tool_id, self.volt_rating, self.amp_rating, self.min_rpm_rating, self.max_rpm_rating])
        for acc in self.accessories:
            cursor.execute("INSERT INTO Accessory (description, quantity, PowerTool_Id) VALUES (%s, %s, %s)",
                           [acc['desc'], acc['quantity'], self.tool_id])
        return self

class Drill(Power):
    def __init__(self, params):
        super(Drill, self).__init__(params)
        self.adjustable_clutch = params['drill_adjustable_clutch']
        self.min_torque_rating = float(params['drill_min_torque_rating'])
        self.max_torque_rating = float(params['drill_max_torque_rating'])

    def create(self, cursor):
        super(Drill, self).create(cursor)
        cursor.execute("INSERT INTO PowerDrill \
                       VALUES (%s, %s, %s, %s)",
                       [self.tool_id, self.adjustable_clutch, self.min_torque_rating, self.max_torque_rating])
        return self

class Saw(Power):
    def __init__(self, params):
        super(Saw, self).__init__(params)
        self.blade_size = float(params['saw_blade_size'])

    def create(self, cursor):
        super(Saw, self).create(cursor)
        cursor.execute("INSERT INTO PowerSaw \
                       VALUES (%s, %s)",
                       [self.tool_id, self.blade_size])
        return self

class Sander(Power):
    def __init__(self, params):
        super(Sander, self).__init__(params)
        self.dust_bag = params['sander_dust_bag']

    def create(self, cursor):
        super(Sander, self).create(cursor)
        cursor.execute("INSERT INTO PowerSander \
                       VALUES (%s, %s)",
                       [self.tool_id, self.dust_bag])
        return self

class AirCompressor(Power):
    def __init__(self, params):
        super(AirCompressor, self).__init__(params)
        self.tank_size = float(params['ac_tank_size'])
        self.pressure_rating = float(params['ac_pressure_rating'])

    def create(self, cursor):
        super(AirCompressor, self).create(cursor)
        cursor.execute("INSERT INTO PowerAirCompressor \
                       VALUES (%s, %s, %s)",
                       [self.tool_id, self.tank_size, self.pressure_rating])
        return self

class Mixer(Power):
    def __init__(self, params):
        super(Mixer, self).__init__(params)
        self.motor_rating = float(params['mixer_motor_rating'])
        self.drum_size = float(params['mixer_drum_size'])

    def create(self, cursor):
        super(Mixer, self).create(cursor)
        cursor.execute("INSERT INTO PowerMixer \
                       VALUES (%s, %s, %s)",
                       [self.tool_id, self.motor_rating, self.drum_size])
        return self

class Generator(Power):
    def __init__(self, params):
        super(Generator, self).__init__(params)
        self.power_rating = float(params['generator_power_rating'])

    def create(self, cursor):
        super(Generator, self).create(cursor)
        cursor.execute("INSERT INTO PowerGenerator \
                       VALUES (%s, %s)",
                       [self.tool_id, self.power_rating])
        return self

class Ladder(Tool):
    def __init__(self, params):
        super(Ladder, self).__init__(params)
        self.step_count = int(params['step_count'])
        self.weight_capacity = float(params['weight_capacity'])

    def create(self, cursor):
        super(Ladder, self).create(cursor)
        cursor.execute("INSERT INTO LadderTool VALUES (%s, %s, %s)",
                       [self.tool_id, self.step_count, self.weight_capacity])
        return self

class Straight(Ladder):
    def __init__(self, params):
        super(Straight, self).__init__(params)
        self.rubber_feet = params['straight_rubber_feet']

    def create(self, cursor):
        super(Straight, self).create(cursor)
        cursor.execute("INSERT INTO StraightLadder \
                       VALUES (%s, %s)",
                       [self.tool_id, self.rubber_feet])
        return self

class Step(Ladder):
    def __init__(self, params):
        super(Step, self).__init__(params)
        self.pail_shelf = params['step_pail_shelf']

    def create(self, cursor):
        super(Step, self).create(cursor)
        cursor.execute("INSERT INTO StepLadder \
                       VALUES (%s, %s)",
                       [self.tool_id, self.pail_shelf])
        return self
