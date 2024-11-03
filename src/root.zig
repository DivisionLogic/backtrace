const std = @import("std");

/// Creates a StackTrace using the current code location.
/// Addresses buffer must live as long as the returned StackTrace.
/// A good size for addresses buffer is 32.
/// # Example
/// ```
/// var addrs: [32]usize = undefined;
/// const stacktrace = backtrace(addrs[0..]);
/// std.debug.dumpStackTrace(stacktrace);
/// ```
/// # See also
/// std.debug.writeStackTrace;
pub fn backtrace(addresses_buffer: []usize) std.builtin.StackTrace {
    const current_address = @returnAddress();

    @memset(addresses_buffer, 0);

    var stacktrace = std.builtin.StackTrace{
        .instruction_addresses = addresses_buffer,
        .index = 0,
    };

    std.debug.captureStackTrace(current_address, &stacktrace);
    return stacktrace;
}

fn test_fn(value: u32) void {
    if (value > 0) {
        test_fn(value - 1);
    } else {
        // TODO fix so it prints in a file rather than in the test.
        //var addrs: [128]usize = undefined;
        //const stacktrace = backtrace(addrs[0..]);
        //std.debug.dumpStackTrace(stacktrace);
    }
}

test "shallow" {
    test_fn(1);
}

test "deep" {
    test_fn(65);
}


