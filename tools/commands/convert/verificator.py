"""
Verificators structure.
"""

import itertools as it
import logging
import math
import re


class Struct:
    """Class to convert a dictionary to an object"""

    def __init__(self, **entries):
        self.__dict__.update(entries)


def typesize(typename):
    """Type size in bytes"""
    size = re.findall(r"\d+", typename)
    if len(size) == 1:
        return int(size[0]) // 8
    return 1


def typeof(signal):
    """Type of a signal"""
    return signal["Type"]


def same_type(signal_a, signal_b):
    """check if two signals have the same type"""
    return typeof(signal_a) == typeof(signal_b) and sizeof(signal_a) == sizeof(signal_b)


# pairwise() from Itertools Recipes
def pairwise(iterable):
    return zip(*[iter(iterable)] * 2)


def sizeof(signal):
    """Signal size in bytes."""
    if "NumberOfElements" in signal:
        num_dim = (
            1 if "NumberOfDimensions" not in signal else signal["NumberOfDimensions"]
        )
        num_el = signal["NumberOfElements"]
        if isinstance(num_el, list) or isinstance(num_el, tuple):
            num_el = math.prod(num_el)
        if "Ranges" in signal:
            num_el = 0
            for i in range(num_dim):
                dim_range = signal["Ranges"][i]
                num_el += dim_range[1] - dim_range[0] + 1
        return typesize(signal["Type"]) * num_el
    return typesize(signal["Type"])


def even(number):
    return number % 2 == 0


def odd(number):
    return number % 2 != 0


def verify(obj):
    """Verify a GAM using self function."""
    if "$CHECK" in obj:
        fn = eval("lambda this: " + obj["$CHECK"])
        return fn(Struct(**obj))
    return True


Verificators = {}
