"""
JSON object processors.
"""
import copy
import sys
import logging

from verificator import verify
from collections import OrderedDict

def clean_list_private(obj):
    res = []
    for el in obj:
        if isinstance(el, dict):
            res.append(clean_private(el))
        elif isinstance(el, list):
            res.append(clean_list_private(el))
        else:
            res.append(el)
    return res


def clean_private(obj):
    res = copy.deepcopy(obj)
    for key, val in obj.items():
        if key[0] == '$':
            del res[key]
        elif isinstance(val, dict):
            res[key] = clean_private(val)
        elif  isinstance(val, list):
            res[key] = clean_list_private(val)
    return res

def clean_list_empty(obj):
    res = []
    for el in obj:
        if isinstance(el, dict):
            res.append(clean_empty(el))
        elif isinstance(el, list):
            res.append(clean_list_empty(el))
        else:
            res.append(el)
    return res


def clean_empty(obj):
    res = copy.deepcopy(obj)
    for key, val in obj.items():
        if isinstance(val, dict):
            if not val:
                del res[key]
            else:
                res[key] = clean_empty(val)
        if isinstance(val, list):
            res[key] = clean_list_empty(val)
            if not val:
                del res[key]
    return res


def marte_syntax(obj):
    res = OrderedDict()
    for key, val in obj.items():
        if isinstance(val, dict):
            if 'Class' in val:
                if val['Class'] == 'RealTimeApplication':
                    key = f'${key}'
                else:
                    key = f'+{key}'
            res[key] = marte_syntax(val)
        else:
            res[key] = val
    return res



def process_gam_signals(signals, label="Signal"):
    res = OrderedDict()
    for key, signal in signals.items():
        obj = copy.deepcopy(signal)
        del obj['Signal']
        obj['DataSource'] = signal['Signal']['$SOURCE']
        if signal['Signal']['$ID'] != key:
            logging.info(f"signal {key} is alias of {signal['Signal']['$SOURCE']}.{signal['Signal']['$ID']}")
            obj['Alias'] = signal['Signal']['$ID']
        obj['Type'] = signal['Signal']['Type']
        if 'NumberOfElements' in signal['Signal']:
            obj['NumberOfElements'] = signal['Signal']['NumberOfElements']
        res[key] = obj
    return res


def process_vinstds(datasource, _): 
    """Process VInst:VInstDataSource"""
    if "Commands" in datasource:
        for cname, command in datasource["Commands"].items():
            if "Signals" in command:
                sigs = copy.deepcopy(command['Signals'])
                command['Signals'] = OrderedDict()
                for obj in sigs:
                    signal = obj['Signal']
                    value = obj['Value']
                    command['Signals'][signal] = value
    return datasource


def process_app(app, _):
    """Process application json object."""
    for gam_name, gam in app['Functions'].items():
        logging.info(f"processing GAM: {gam_name}")
        if 'Class' in gam and gam['Class'] in Processors: 
            gam = Processors[gam['Class']](gam)
            app['Functions'][gam_name] = gam
        #if '$GAM' in gam:
            #gam['InputSignals'] = process_gam_signals(gam['InputSignals'], label='Input')
            #gam['OutputSignals'] = process_gam_signals(gam['OutputSignals'], label='Output')
        if 'Class' in gam and not verify(gam):
            logging.error(f'Verification of {gam_name} failed!')
            sys.exit(1)
    if 'Data' in app:
        #app['Data']['DefaultDataSource'] = app['Data']['DefaultDataSource']['$DataSource']
        for dm_name, datasource in app['Data'].items():
            if isinstance(datasource, dict):
                if 'Class' in datasource and datasource['Class'] in Processors: 
                    datasource = Processors[datasource['Class']](datasource)
                    app['Data'][dm_name] = datasource
    if 'States' in app:
        logging.info("processing States")
        for sname, state in app['States'].items():
            logging.info(f"processing state: {sname}")
            if not isinstance(state, dict):
                continue
            for thread in state['Threads'].values():
                if not isinstance(thread, dict):
                    continue
                #thread['Functions'] = list(gam['$GAM'] for gam in thread['Functions'])
    else:
        logging.error("no States defined")
        sys.exit(1)
    return app


def process_obj(obj, _):
    return obj


def get(key, root):
    keys = key.split('.')
    el = root
    while len(keys) > 0 and keys[0] in el:
        el = el[keys.pop(0)]
    if len(keys) == 0:
        return el
    return None
    #for k, v in root.items():
    #    if k == key and isinstance(v, dict) and 'Class' in v:
    #        return v
    #for v in root.values():
    #   if isinstance(v, dict) and 'Class' in v:
    #        return get(key, v)
    #return None


def process_message(obj, root):
    if get(obj['Destination'], root) is None:
        logging.error(f"Message destination `{obj['Destination']}` not found")
        return obj 
    return obj


def __process_state__(obj, root):
    logging.info(f"Processing StateMachine:State`")

    res = OrderedDict()
    for key, val in obj.items():
        if isinstance(val, dict): 
            res[key] = process_StateMachineEvent(val, root)
        else:
            res[key] = val
    return res


def process_sm(obj, root):
    logging.info(f"Processing StateMachine")
    res = OrderedDict()
    for key, val in obj.items():
        if isinstance(val, dict):
            res[key] = __process_state__(val, root)
        else:
            res[key] = val
    return res


def process_StateMachineEvent(obj, root):
    logging.info(f'Processing StateMachineEvent')
    res = OrderedDict()
    for key, val in obj.items():
        if isinstance(val, dict):
            res[key] = process_message(val, root)
        else:
            res[key] = val
    return res

    
def process_thread(obj, _):
    return obj


Processors = {
  "RealTimeApplication":  process_app,
  "StateMachine": process_sm,
  "**": process_obj,
  #"VInst::VInstDataSource": process_vinstds,
  #"Message": process_message,
  "RealTimeThread": process_thread,
}

